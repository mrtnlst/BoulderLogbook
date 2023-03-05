//
//  EntryForm.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct EntryForm: ReducerProtocol {
    struct State: Equatable {
        let id: UUID
        var tops: [Top] // TODO: @BindingState?
        var attempts: [Top] // TODO: @BindingState?
        var flashs: [Top] // TODO: @BindingState?
        var onsights: [Top] // TODO: @BindingState?
        var gradeSystems: [GradeSystem] = []
        var isEditing: Bool
        
        @BindingState var date: Date
        @BindingState var selectedSystemId: UUID?
        /// Temporary store selected value and assign after available systems are fetched. Avoids Picker warning in console.
        fileprivate var tempSelectedSystemId: UUID?
        
        var selectedSystem: GradeSystem? {
            gradeSystems.first(where: { $0.id == selectedSystemId })
        }
        
        init(
            id: UUID = UUID(),
            date: Date = .now,
            tops: [Top] = [],
            attempts: [Top] = [],
            flashs: [Top] = [],
            onsights: [Top] = [],
            selectedSystem: UUID? = nil,
            isEditing: Bool = false
        ) {
            self.id = id
            self.date = date
            self.tops = tops
            self.attempts = attempts
            self.flashs = flashs
            self.onsights = onsights
            self.tempSelectedSystemId = selectedSystem
            self.isEditing = isEditing
        }
    }
    
    enum Action: BindableAction {
        case onAppear
        case fetchAvailableSystems
        case fetchSelectedSystem
        case receiveAvailableSystems(TaskResult<[GradeSystem]>)
        case receiveSelectedSystem(TaskResult<UUID?>)
        case increaseTop(GradeSystem.Grade)
        case decreaseTop(GradeSystem.Grade)
        case increaseAttempt(GradeSystem.Grade)
        case decreaseAttempt(GradeSystem.Grade)
        case increaseFlash(GradeSystem.Grade)
        case decreaseFlash(GradeSystem.Grade)
        case increaseOnsight(GradeSystem.Grade)
        case decreaseOnsight(GradeSystem.Grade)
        case save
        case saveDidFinish(TaskResult<EntryClientResponse>)
        case cancel
        case binding(BindingAction<State>)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.entryClient) var entryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate(
                    .task { .fetchAvailableSystems },
                    .task { .fetchSelectedSystem }
                )
                
            case .fetchAvailableSystems:
                return .task {
                    await .receiveAvailableSystems(
                        TaskResult { gradeSystemClient.fetchAvailableSystems() }
                    )
                }
                
            case .fetchSelectedSystem:
                guard state.selectedSystemId == nil else {
                    return .none
                }
                return .task {
                    await .receiveSelectedSystem(
                        TaskResult { gradeSystemClient.fetchSelectedSystem() }
                    )
                }
                
            case let .receiveAvailableSystems(.success(gradeSystems)):
                if state.gradeSystems.isEmpty {
                    state.gradeSystems = gradeSystems
                } else {
                    var gradeSystemsCopy = state.gradeSystems
                    gradeSystemsCopy.append(contentsOf: gradeSystems)
                    state.gradeSystems = gradeSystemsCopy.distinct(by: \.id)
                }
                // Set `selectedSystemId` only when available values for SwiftUI.Picker are available.
                if let tempSelectedSystemId = state.tempSelectedSystemId {
                    state.selectedSystemId = tempSelectedSystemId
                    state.tempSelectedSystemId = nil
                }
                return .none
                
            case let .receiveSelectedSystem(.success(selected)):
                guard state.selectedSystemId == nil else {
                    return .none
                }
                state.selectedSystemId = selected
                return .none
            
            case let .increaseTop(grade):
                let top = Top(grade: grade.id)
                state.tops.append(top)
                return .none
                
            case let .decreaseTop(grade):
                if let index = state.tops.firstIndex(where: { $0.grade == grade.id }) {
                    state.tops.remove(at: index)
                }
                return .none
                
            case let .increaseAttempt(grade):
                let attempt = Top(grade: grade.id, isAttempt: true)
                state.attempts.append(attempt)
                return .none
                
            case let .decreaseAttempt(grade):
                if let index = state.attempts.firstIndex(where: { $0.grade == grade.id }) {
                    state.attempts.remove(at: index)
                }
                return .none
                
            case let .increaseFlash(grade):
                let flash = Top(grade: grade.id, wasFlash: true)
                state.flashs.append(flash)
                return .none
                
            case let .decreaseFlash(grade):
                if let index = state.flashs.firstIndex(where: { $0.grade == grade.id }) {
                    state.flashs.remove(at: index)
                }
                return .none
                
            case let .increaseOnsight(grade):
                let onsight = Top(grade: grade.id, wasOnsight: true)
                state.onsights.append(onsight)
                return .none
                
            case let .decreaseOnsight(grade):
                if let index = state.onsights.firstIndex(where: { $0.grade == grade.id }) {
                    state.onsights.remove(at: index)
                }
                return .none
                
            case .save:
                guard let gradeSystemId = state.selectedSystemId else {
                    return .none
                }
                let entry = Logbook.Section.Entry(
                    id: state.id,
                    date: state.date,
                    tops: state.tops + state.attempts + state.flashs + state.onsights,
                    gradeSystem: gradeSystemId
                )
                return .task {
                    await .saveDidFinish(
                        TaskResult {
                            entryClient.saveEntry(entry)
                            return .finished
                        }
                    )
                }
            
            case .binding(\.$selectedSystemId):
                state.tops.removeAll()
                state.attempts.removeAll()
                state.flashs.removeAll()
                state.onsights.removeAll()
                return .none
                
            default:
                return .none
            }
        }
    }
}
