//
//  TrainingFormFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 18.10.25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TrainingFormFeature {
    @ObservableState
    struct State: Equatable {
        var id: UUID
        var date: Date
        var exercise: Exercise?
        var result: TrainingResultFeature.State

        var exercises: [Exercise] = []
        
        init(
            id: UUID = UUID(),
            date: Date = .now,
            exercise: Exercise? = nil,
            result: Training.Result = .repititions(0)
        ) {
            self.id = id
            self.date = date
            self.exercise = exercise
            self.result = .init(result: result)
        }
    }
    
    enum Action: ViewAction {
        enum View {
            case onAppear
            case save
            case cancel
        }
        case fetchExercises
        case receiveExercises(TaskResult<[Exercise]>)
        case didSelectExercise(Exercise?)
        case didSelectDate(Date?)
        case saveDidFinish(TaskResult<ClientResponse>)
        case result(TrainingResultFeature.Action)
        case view(View)
        enum ClientResponse { case finished }
    }
    
    @Dependency(ExerciseClient.self) var exerciseClient
    @Dependency(TrainingClient.self) var trainingClient
    
    var body: some ReducerOf<TrainingFormFeature> {
        Scope(state: \.result, action: \.result) {
            TrainingResultFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .send(.fetchExercises)
                
            case .view(.save):
                guard let exercise = state.exercise else {
                    return .none
                }
                let training = Training(
                    id: state.id,
                    date: state.date,
                    exercise: exercise,
                    result: state.result.selectedValue
                )
                return .run { send in
                    await send(
                        .saveDidFinish(
                            TaskResult {
                                await trainingClient.saveTraining(training)
                                return .finished
                            }
                        )
                    )
                }
                
            case .fetchExercises:
                return .run { send in
                    await send(
                        .receiveExercises(
                            TaskResult { await exerciseClient.fetchExercises() }
                        )
                    )
                }
                
            case let .receiveExercises(.success(exercises)):
                state.exercises = exercises
                
            case let .didSelectExercise(exercise):
                state.exercise = exercise
                
            case let .didSelectDate(date):
                state.date = date ?? .now

            default: ()
            }
            return .none
        }
    }
}
