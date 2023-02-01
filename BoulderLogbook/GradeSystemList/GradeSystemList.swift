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
        case saveSelected(UUID)
        case saveSelectedDidFinish(TaskResult<ClientResponse>)
        case delete(UUID)
        case edit(UUID)
        
        enum ClientResponse { case finished }
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
                
            case .gradeSystemForm(.cancel):
                return .task { .setIsPresentingForm(false) }
                
            case .gradeSystemForm(.saveDidFinish(_)):
                return .concatenate(
                    .task { .setIsPresentingForm(false) },
                    .task { .fetchAvailableSystems }
                )

            case let .setIsPresentingForm(isPresenting):
                state.isPresentingForm = isPresenting
                state.gradeSystemForm = isPresenting ? GradeSystemForm.State() : nil
                return .none
                
            case let .delete(id):
                guard let oldValue = state.gradeSystems.first (where: { $0.id == id }) else {
                    return .none
                }
                return .merge(
                    .fireAndForget { client.deleteSystem(oldValue) },
                    .task { .fetchAvailableSystems }
                )
            
            case let .saveSelected(id):
                guard state.selectedSystem?.id != id else {
                    return .none
                }
                return .task {
                    await .saveSelectedDidFinish(
                        TaskResult {
                            client.saveSelectedSystem(id)
                            return .finished
                        }
                    )
                }

            case .saveSelectedDidFinish(_):
                return .task { .fetchSelectedSystem }
                
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
    
            default:
                return .none
            }
        }
        .ifLet(\.gradeSystemForm, action: /Action.gradeSystemForm) {
            GradeSystemForm()
        }
    }
}

