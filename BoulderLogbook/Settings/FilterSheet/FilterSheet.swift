//
//  FilterSheet.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.01.23.
//

import Foundation
import ComposableArchitecture

struct FilterSheet: ReducerProtocol {
    struct State: Equatable {
        var gradeSystems: [GradeSystem] = []
        @BindingState var selectedSystemId: UUID?
    }
    
    enum Action: Equatable, BindableAction {
        case onAppear
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.gradeSystemClient) var client
    @Dependency(\.filterClient) var filterClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
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
                        TaskResult { filterClient.fetchFilterSystem() }
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedSystemId = selected
                return .none
                
            case .binding(\.$selectedSystemId):
                return .fireAndForget { [state] in
                    filterClient.saveFilterSystem(state.selectedSystemId)
                }
            
            default:
                return .none
            }
        }
    }
}
