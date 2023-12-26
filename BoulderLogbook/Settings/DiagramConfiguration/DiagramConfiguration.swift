//
//  DiagramPage.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DiagramConfiguration {
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
        case saveDidFinish(TaskResult<FilterClientResponse>)
        case binding(BindingAction<State>)
        
        enum FilterClientResponse { case finished }
    }
    
    @Dependency(\.gradeSystemClient) var client
    @Dependency(\.filterClient) var filterClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchGradeSystems)
                
            case .fetchGradeSystems:
                return .run { send in
                    await send(
                        .receiveGradeSystems(TaskResult { client.fetchAvailableSystems() } )
                    )
                }
                
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .send(.fetchSelectedSystem)
                
            case .fetchSelectedSystem:
                return .run { send in
                    await send(
                        .receiveSelectedSystem(TaskResult { filterClient.fetchFilterSystem() })
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedSystemId = selected
                
            case .binding(\.$selectedSystemId):
                return .run { [state] send in
                    await send(
                        .saveDidFinish(
                            TaskResult {
                                filterClient.saveFilterSystem(state.selectedSystemId)
                                return .finished
                            }
                        )
                    )
                }
            
            default: ()
            }
            return .none
        }
    }
}
