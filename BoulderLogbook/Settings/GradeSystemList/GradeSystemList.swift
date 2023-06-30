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
        var isPresentingConfirmation: Bool = false
        var systemToDelete: GradeSystem?
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case setIsPresentingForm(Bool)
        case setIsPresentingConfirmation(Bool)
        case saveSelected(UUID)
        case saveSelectedDidFinish(TaskResult<ClientResponse>)
        case setSystemToDelete(GradeSystem)
        case confirmDelete
        case cancelDelete
        case delete(UUID)
        case edit(UUID)
        case gradeSystemForm(GradeSystemForm.Action)
        
        enum ClientResponse { case finished }
    }
    
    @Dependency(\.gradeSystemClient) var client
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchGradeSystems)
                
            case .fetchGradeSystems:
                return .run { send in
                    await send(
                        .receiveGradeSystems(TaskResult { client.fetchAvailableSystems() })
                    )
                }
                
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .send(.fetchSelectedSystem)
                
            case .fetchSelectedSystem:
                return .run { send in
                    await send(
                        .receiveSelectedSystem(TaskResult { client.fetchSelectedSystem() })
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedSystem = state.gradeSystems.first(where: { $0.id == selected })

            case let .setIsPresentingForm(isPresenting):
                state.isPresentingForm = isPresenting
                state.gradeSystemForm = isPresenting ? GradeSystemForm.State() : nil
                
            case let .setIsPresentingConfirmation(isPresenting):
                state.isPresentingConfirmation = isPresenting
                
            case let .saveSelected(selected):
                guard state.selectedSystem?.id != selected else {
                    return .none
                }
                return .run { send in
                    await send(
                        .saveSelectedDidFinish(
                            TaskResult {
                                client.saveSelectedSystem(selected)
                                return .finished
                            }
                        )
                    )
                }
                
            case .saveSelectedDidFinish(_):
                return .send(.fetchSelectedSystem)
                
            case let .setSystemToDelete(system):
                state.systemToDelete = system
                return .send(.setIsPresentingConfirmation(true))
                
            case .confirmDelete:
                guard let systemToDelete = state.systemToDelete else {
                    return .none
                }
                return .send(.delete(systemToDelete.id))
                
            case .cancelDelete:
                state.systemToDelete = nil
                
            case let .delete(id):
                return .merge(
                    .run { _ in client.deleteSystem(id) },
                    .send(.fetchGradeSystems)
                )
                
            case let .edit(id):
                guard let gradeSystem = state.gradeSystems.first (where: { $0.id == id }) else {
                    return .none
                }
                let formState = GradeSystemForm.State(
                    id: gradeSystem.id,
                    name: gradeSystem.name,
                    grades: gradeSystem.grades
                )
                state.gradeSystemForm = formState
                state.isPresentingForm = true
    
            case .gradeSystemForm(.cancel):
                return .send(.setIsPresentingForm(false))
                
            case .gradeSystemForm(.saveDidFinish(_)):
                return .concatenate(
                    .send(.setIsPresentingForm(false)),
                    .send(.fetchGradeSystems)
                )
                
            default: ()
            }
            return .none
        }
        .ifLet(\.gradeSystemForm, action: /Action.gradeSystemForm) {
            GradeSystemForm()
        }
    }
}

