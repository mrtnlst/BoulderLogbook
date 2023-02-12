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
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case setIsPresentingForm(Bool)
        case saveSelected(UUID)
        case saveSelectedDidFinish(TaskResult<ClientResponse>)
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
                return .task { .fetchGradeSystems }
                
            case .fetchGradeSystems:
                return .task {
                    await .receiveGradeSystems(
                        TaskResult { client.fetchAvailableSystems() }
                    )
                }
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .task { .fetchSelectedSystem }
                
            case .fetchSelectedSystem:
                return .task {
                    await .receiveSelectedSystem(
                        TaskResult { client.fetchSelectedSystem() }
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedSystem = state.gradeSystems.first(where: { $0.id == selected })
                return .none

            case let .setIsPresentingForm(isPresenting):
                state.isPresentingForm = isPresenting
                state.gradeSystemForm = isPresenting ? GradeSystemForm.State() : nil
                return .none
                
            case let .saveSelected(selected):
                guard state.selectedSystem?.id != selected else {
                    return .none
                }
                return .task {
                    await .saveSelectedDidFinish(
                        TaskResult {
                            client.saveSelectedSystem(selected)
                            return .finished
                        }
                    )
                }
                
            case .saveSelectedDidFinish(_):
                return .task { .fetchSelectedSystem }
                
            case let .delete(oldValue):
                return .merge(
                    .fireAndForget { client.deleteSystem(oldValue) },
                    .task { .fetchGradeSystems }
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
                return .none
    
            case .gradeSystemForm(.cancel):
                return .task { .setIsPresentingForm(false) }
                
            case .gradeSystemForm(.saveDidFinish(_)):
                return .concatenate(
                    .task { .setIsPresentingForm(false) },
                    .task { .fetchGradeSystems }
                )
                
            default:
                return .none
            }
        }
        .ifLet(\.gradeSystemForm, action: /Action.gradeSystemForm) {
            GradeSystemForm()
        }
    }
}

