//
//  GradeSystemList.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import ComposableArchitecture

struct GradeSystemList: ReducerProtocol {
    public struct State: Equatable {
        var gradeSystems: [GradeSystem] = [mandalaGrades, kletterarenaGrades]
        var selectedSystem: GradeSystem?
        var gradeSystemForm: GradeSystemForm.State?
        var isPresentingForm: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchAvailableSystems
        case fetchSelectedSystem
        case receiveAvailableSystems(TaskResult<[GradeSystem]>)
        case receiveSelectedSystem(TaskResult<GradeSystem>)
        case gradeSystemForm(GradeSystemForm.Action)
        case setIsPresentingForm(Bool)
        case deleteSystem(IndexSet)
    }
    
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    .task { .fetchAvailableSystems },
                    .task { .fetchSelectedSystem }
                )
                
            case .fetchAvailableSystems:
                return .task {
                    await .receiveAvailableSystems(TaskResult { gradeSystemClient.fetchAvailableSystems() })
                }
                
            case .fetchSelectedSystem:
                return .none
                
            case let .receiveAvailableSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .none
                
            case let .receiveSelectedSystem(.success(selectedSystem)):
                state.selectedSystem = selectedSystem
                return .none
                
            case .receiveAvailableSystems(.failure),
                    .receiveSelectedSystem(.failure):
                return .none
                
            case .gradeSystemForm(.cancel):
                return .task { .setIsPresentingForm(false) }
                
            case .gradeSystemForm(.save):
                return .merge(
                    .task { .setIsPresentingForm(false) },
                    .task { .fetchAvailableSystems }
                )
                
            case .gradeSystemForm(_):
                return .none
                
            case let .setIsPresentingForm(isPresenting):
                state.isPresentingForm = isPresenting
                state.gradeSystemForm = isPresenting ? GradeSystemForm.State() : nil
                return .none
                
            case let .deleteSystem(from):
                let oldValues = from.map { state.gradeSystems[$0] }
                return .merge(
                    .fireAndForget { gradeSystemClient.deleteSystems(oldValues) },
                    .task { .fetchAvailableSystems }
                )
            }
        }
        .ifLet(\.gradeSystemForm, action: /Action.gradeSystemForm) {
            GradeSystemForm()
        }
    }
}

