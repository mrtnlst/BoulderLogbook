//
//  ExerciseFormFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ExerciseFormFeature {
    @ObservableState
    struct State: Equatable {
        let id: UUID
        var name: String
        var symbol: String?

        init(
            id: UUID = UUID(),
            name: String = "",
            symbol: String? = nil
        ) {
            self.id = id
            self.name = name
            self.symbol = symbol
        }
    }
    
    enum Action: ViewAction {
        enum View {
            case save
            case cancel
        }
        case didEditName(String)
        case didSelectSymbol(String?)
        case saveDidFinish(TaskResult<ClientResponse>)
        case view(View)
        
        enum ClientResponse { case finished }
    }
    
    @Dependency(ExerciseClient.self) var client
    
    var body: some ReducerOf<ExerciseFormFeature> {
        Reduce { state, action in
            switch action {
            case let .didEditName(name):
                state.name = name
                
            case let .didSelectSymbol(symbol):
                state.symbol = symbol
                
            case .view(.save):
                let exercise = Exercise(
                    id: state.id,
                    name: state.name,
                    symbol: state.symbol ?? "None"
                )
                return .run { send in
                    await send(
                        .saveDidFinish(
                            TaskResult {
                                await client.saveExercise(exercise)
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
