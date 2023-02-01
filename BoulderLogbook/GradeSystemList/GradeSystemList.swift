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
        var gradeSystems: [GradeSystem] = []
        var selectedSystem: GradeSystem?
        var gradeSystemForm: GradeSystemForm.State?
        var isPresentingForm: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchAvailableSystems
        case fetchSelectedSystem
        case receiveAvailableSystems(TaskResult<[GradeSystem]>)
        case receiveSelectedSystem(TaskResult<UUID?>)
        case gradeSystemForm(GradeSystemForm.Action)
        case setIsPresentingForm(Bool)
        case deleteSystem(IndexSet)
        case saveSelectedSystem(UUID)
    }
    
    @Dependency(\.gradeSystemClient) var client
    @Dependency(\.continuousClock) var clock
    
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
                    await .receiveAvailableSystems(
                        TaskResult { client.fetchAvailableSystems() }
                    )
                }
                
            case .fetchSelectedSystem:
                return .task {
                    await .receiveSelectedSystem(
                        TaskResult { client.fetchSelectedSystem() }
                    )
                }
                
            case let .receiveAvailableSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .none
                
            case let .receiveSelectedSystem(.success(id)):
                state.selectedSystem = state.gradeSystems.first { $0.id == id }
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
                    .fireAndForget { client.deleteSystems(oldValues) },
                    .task { .fetchAvailableSystems }
                )
            
            case let .saveSelectedSystem(id):
                return .merge(
                    .fireAndForget { client.saveSelectedSystem(id) },
                    .task {
                        try await clock.sleep(for: .milliseconds(50))
                        return .fetchSelectedSystem
                    }
                )
            }
        }
        .ifLet(\.gradeSystemForm, action: /Action.gradeSystemForm) {
            GradeSystemForm()
        }
    }
}

