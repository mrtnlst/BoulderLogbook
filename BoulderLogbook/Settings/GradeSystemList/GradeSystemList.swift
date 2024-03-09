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
    @Reducer
    struct Destination {
        enum State: Equatable {
            case gradeSystemForm(GradeSystemForm.State)
            case confirmationDialog(ConfirmationDialogState<Action.Confirmation>)
        }
        enum Action: Equatable {
            case gradeSystemForm(GradeSystemForm.Action)
            case confirmationDialog(PresentationAction<Confirmation>)
            
            enum Confirmation {
                case delete
            }
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.gradeSystemForm, action: \.gradeSystemForm) {
                GradeSystemForm()
            }
        }
    }
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var gradeSystems: [GradeSystem] = []
        var selectedSystem: GradeSystem?
        var systemToDelete: GradeSystem?
    }
    
    enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<GradeSystem?>)
        case presentGradeSystemForm
        case presentConfirmation
        case saveSelected(UUID)
        case saveSelectedDidFinish(TaskResult<ClientResponse>)
        case setSystemToDelete(GradeSystem)
        case delete(UUID)
        case edit(UUID)
        
        enum ClientResponse { case finished }
    }
    
    @Dependency(\.gradeSystemClient) var client
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
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

            case .presentGradeSystemForm:
                state.destination = .gradeSystemForm(GradeSystemForm.State())
                
            case .presentConfirmation:
                let name = state.systemToDelete?.name ?? ""
                state.destination = .confirmationDialog(
                    ConfirmationDialogState {
                        TextState("Warning")
                    } actions: {
                        ButtonState(role: .destructive, action: .delete) {
                            TextState("Delete")
                        }
                    } message: {
                        TextState("Deleting \(name) removes all of its logbook entries!")
                    }
                )

            case .destination(.presented(.confirmationDialog(.dismiss))):
                state.destination = nil

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
                return .send(.presentConfirmation)
                
            case .destination(.presented(.confirmationDialog(.presented(.delete)))):
                guard let systemToDelete = state.systemToDelete else {
                    return .none
                }
                return .send(.delete(systemToDelete.id))

            case let .delete(id):
                return .concatenate(
                    .run { _ in await client.deleteSystem(id) },
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
        .ifLet(\.$destination, action: \.destination) {
          Destination()
        }
    }
}

