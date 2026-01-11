//
//  ExerciseListFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ExerciseListFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case exerciseForm(ExerciseFormFeature)
        case confirmationDialog(AlertState<Confirmation>)

        @CasePathable
        enum Confirmation {
            case delete
        }
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var exercises: [Exercise] = []
        var exerciseToDelete: Exercise?
    }
    
    enum Action: ViewAction {
        enum View {
            case onAppear
            case presentExerciseForm
            case setExerciseToDelete(Exercise)
            case edit(UUID)
        }
        case destination(PresentationAction<Destination.Action>)
        case fetchExercises
        case receiveExercises(TaskResult<[Exercise]>)
        case presentConfirmation
        case delete(UUID)
        case view(View)
        
        enum ClientResponse { case finished }
    }
    
    @Dependency(ExerciseClient.self) var client
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .send(.fetchExercises)
                
            case .fetchExercises:
                return .run { send in
                    await send(
                        .receiveExercises(TaskResult { await client.fetchExercises() })
                    )
                }
                
            case let .receiveExercises(.success(exercises)):
                state.exercises = exercises

            case .view(.presentExerciseForm):
                state.destination = .exerciseForm(ExerciseFormFeature.State())
                
            case .presentConfirmation:
                let name = state.exerciseToDelete?.name ?? ""
                state.destination = .confirmationDialog(
                    AlertState {
                        TextState("Warning")
                    } actions: {
                        ButtonState(role: .destructive, action: .delete) {
                            TextState("Delete")
                        }
                    } message: {
                        TextState("Deleting \(name) removes all of its exercise entries!")
                    }
                )
                
            case let .view(.setExerciseToDelete(exercise)):
                state.exerciseToDelete = exercise
                return .send(.presentConfirmation)
                
            case .destination(.presented(.confirmationDialog(.delete))):
                guard let exerciseToDelete = state.exerciseToDelete else {
                    return .none
                }
                return .send(.delete(exerciseToDelete.id))

            case let .delete(id):
                return .concatenate(
                    .run { _ in await client.deleteExercise(id) },
                    .send(.fetchExercises)
                )
                
            case let .view(.edit(id)):
                guard let exercise = state.exercises.first (where: { $0.id == id }) else {
                    return .none
                }
                let formState = ExerciseFormFeature.State(
                    id: exercise.id,
                    name: exercise.name,
                    symbol: exercise.symbol
                )
                state.destination = .exerciseForm(formState)

            case .destination(.presented(.exerciseForm(.view(.cancel)))):
                state.destination = nil
                
            case .destination(.presented(.exerciseForm(.saveDidFinish))):
                state.destination = nil
                return .send(.fetchExercises)
                
            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

