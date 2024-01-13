//
//  EntryForm.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EntryForm {
    struct State: Equatable {
        let id: UUID
        var tops: [Top]
        var attempts: [Top]
        var flashs: [Top]
        var onsights: [Top]
        var gradeSystems: [GradeSystem] = []
        var isEditing: Bool

        @BindingState var date: Date
        @BindingState var notes: String
        @BindingState var selectedSystemId: UUID?
        /// Temporary store selected value and assign after available systems are fetched. Avoids Picker warning in console.
        fileprivate var tempSelectedSystemId: UUID?
        
        let notesPlaceHolder = "Additional notes …"
        
        var selectedSystem: GradeSystem? {
            gradeSystems.first(where: { $0.id == selectedSystemId })
        }
        
        init(
            id: UUID = UUID(),
            date: Date = .now,
            notes: String? = nil,
            tops: [Top] = [],
            attempts: [Top] = [],
            flashs: [Top] = [],
            onsights: [Top] = [],
            selectedSystem: UUID? = nil,
            isEditing: Bool = false
        ) {
            self.id = id
            self.date = date
            self.notes = notes ?? notesPlaceHolder
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
        case topStepperChanged(Int, GradeSystem.Grade)
        case attemptStepperChanged(Int, GradeSystem.Grade)
        case flashStepperChanged(Int, GradeSystem.Grade)
        case onsightStepperChanged(Int, GradeSystem.Grade)
        case save
        case saveDidFinish(TaskResult<EntryClientResponse>)
        case cancel
        case binding(BindingAction<State>)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.entryClient) var entryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate(
                    .send(.fetchAvailableSystems),
                    .send(.fetchSelectedSystem)
                )
                
            case .fetchAvailableSystems:
                return .run { send in
                    await send(
                        .receiveAvailableSystems(TaskResult { gradeSystemClient.fetchAvailableSystems() })
                    )
                }
                
            case .fetchSelectedSystem:
                guard state.selectedSystemId == nil else {
                    return .none
                }
                return .run { send in
                    await send(
                        .receiveSelectedSystem(TaskResult { gradeSystemClient.fetchSelectedSystem() })
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
                
            case let .receiveSelectedSystem(.success(selected)):
                guard state.selectedSystemId == nil else {
                    return .none
                }
                state.selectedSystemId = selected
                
            case let .topStepperChanged(value, grade):
                if value > state.tops.count {
                    state.tops.append(
                        Top(grade: grade.id)
                    )
                } else {
                    if let index = state.tops.firstIndex(where: { $0.grade == grade.id }) {
                        state.tops.remove(at: index)
                    }
                }

            case let .attemptStepperChanged(value, grade):
                if value > state.attempts.count {
                    state.attempts.append(
                        Top(grade: grade.id, isAttempt: true)
                    )
                } else {
                    if let index = state.attempts.firstIndex(where: { $0.grade == grade.id }) {
                        state.attempts.remove(at: index)
                    }
                }

            case let .flashStepperChanged(value, grade):
                if value > state.flashs.count {
                    state.flashs.append(
                        Top(grade: grade.id, wasFlash: true)
                    )
                } else {
                    if let index = state.flashs.firstIndex(where: { $0.grade == grade.id }) {
                        state.flashs.remove(at: index)
                    }
                }

            case let .onsightStepperChanged(value, grade):
                if value > state.onsights.count {
                    state.onsights.append(
                        Top(grade: grade.id, wasOnsight: true)
                    )
                } else {
                    if let index = state.onsights.firstIndex(where: { $0.grade == grade.id }) {
                        state.onsights.remove(at: index)
                    }
                }
                
            case .save:
                guard let gradeSystemId = state.selectedSystemId else {
                    return .none
                }
                let entry = Logbook.Section.Entry(
                    id: state.id,
                    date: state.date,
                    notes: state.notes == state.notesPlaceHolder ? nil : state.notes,
                    tops: state.tops + state.attempts + state.flashs + state.onsights,
                    gradeSystem: gradeSystemId
                )
                return .run { send in
                    await send(
                        .saveDidFinish(
                            TaskResult {
                                entryClient.saveEntry(entry)
                                return .finished
                            }
                        )
                    )
                }
                
            case .binding(\.$selectedSystemId):
                state.tops.removeAll()
                state.attempts.removeAll()
                state.flashs.removeAll()
                state.onsights.removeAll()
                
            default: ()
            }
            return .none
        }
    }
}
