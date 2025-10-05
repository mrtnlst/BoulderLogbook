//
//  GradeSystemList.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GradeSystemList {
    @Reducer(state: .equatable)
    enum Destination {
        case gradeSystemForm(GradeSystemForm)
        case confirmationDialog(AlertState<Confirmation>)

        @CasePathable
        enum Confirmation {
            case delete
        }
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var gradeSystems: [GradeSystem] = []
        var selectedSystem: GradeSystem?
        var systemToDelete: GradeSystem?
    }
    
    enum Action: ViewAction {
        enum View {
            case onAppear
            case presentGradeSystemForm
            case setSystemToDelete(GradeSystem)
            case edit(UUID)
        }
        case destination(PresentationAction<Destination.Action>)
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<GradeSystem?>)
        case presentConfirmation
        case saveSelected(UUID)
        case saveSelectedDidFinish(TaskResult<ClientResponse>)
        case delete(UUID)
        case view(View)
        
        enum ClientResponse { case finished }
    }
    
    @Dependency(GradeSystemClient.self) var client
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .send(.fetchGradeSystems)
                
            case .fetchGradeSystems:
                return .run { send in
                    await send(
                        .receiveGradeSystems(TaskResult { await client.fetchAvailableSystems() })
                    )
                }
                
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .send(.fetchSelectedSystem)
                
            case .fetchSelectedSystem:
                return .run { send in
                    await send(
                        .receiveSelectedSystem(TaskResult { await client.fetchSelectedSystem() })
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedSystem = selected

            case .view(.presentGradeSystemForm):
                state.destination = .gradeSystemForm(GradeSystemForm.State())
                
            case .presentConfirmation:
                let name = state.systemToDelete?.name ?? ""
                state.destination = .confirmationDialog(
                    AlertState {
                        TextState("Warning")
                    } actions: {
                        ButtonState(role: .destructive, action: .delete) {
                            TextState("Delete")
                        }
                    } message: {
                        TextState("Deleting \(name) removes all of its logbook entries!")
                    }
                )

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
                
            case let .view(.setSystemToDelete(system)):
                state.systemToDelete = system
                return .send(.presentConfirmation)
                
            case .destination(.presented(.confirmationDialog(.delete))):
                guard let systemToDelete = state.systemToDelete else {
                    return .none
                }
                return .send(.delete(systemToDelete.id))

            case let .delete(id):
                return .concatenate(
                    .run { _ in await client.deleteSystem(id) },
                    .send(.fetchGradeSystems)
                )
                
            case let .view(.edit(id)):
                guard let gradeSystem = state.gradeSystems.first (where: { $0.id == id }) else {
                    return .none
                }
                let formState = GradeSystemForm.State(
                    id: gradeSystem.id,
                    name: gradeSystem.name,
                    grades: gradeSystem.grades
                )
                state.destination = .gradeSystemForm(formState)

            case .destination(.presented(.gradeSystemForm(.cancel))):
                state.destination = nil
                
            case .destination(.presented(.gradeSystemForm(.saveDidFinish))):
                state.destination = nil
                return .send(.fetchGradeSystems)
                
            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

