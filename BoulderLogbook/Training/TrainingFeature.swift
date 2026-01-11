//
//  TrainingFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TrainingFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case trainingForm(TrainingFormFeature)
        case confirmationDialog(AlertState<Confirmation>)
        
        @CasePathable
        enum Confirmation {
            case delete
        }
    }

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var trainings: [Training] = []
        var trainingToDelete: Training?
    }
    
    enum Action: ViewAction {
        enum View {
            case onAppear
            case presentTrainingForm
            case setTrainingToDelete(Training)
            case edit(UUID)
        }
        case fetchTrainings
        case receiveTrainings(TaskResult<[Training]>)
        case presentConfirmation
        case delete(UUID)
        case deleteDidFinish(TaskResult<ClientResponse>)
        case view(View)
        case destination(PresentationAction<Destination.Action>)
        
        enum ClientResponse { case finished }
    }
    
    @Dependency(TrainingClient.self) var trainingClient
    
    var body: some ReducerOf<TrainingFeature> {
        Reduce { state, action in
            switch action {
            case .view(.presentTrainingForm):
                state.destination = .trainingForm(
                    TrainingFormFeature.State()
                )
                
            case .view(.onAppear):
                return .send(.fetchTrainings)
                
            case .fetchTrainings:
                return .run { send in
                    await send(
                        .receiveTrainings(TaskResult { await trainingClient.fetchTrainings() })
                    )
                }
                
            case let .receiveTrainings(.success(trainings)):
                state.trainings = trainings
                    .sorted(by: { $0.date > $1.date })
                
            case .destination(.presented(.trainingForm(.view(.cancel)))):
                state.destination = nil
                
            case .destination(.presented(.trainingForm(.saveDidFinish(.success)))):
                state.destination = nil
                return .send(.fetchTrainings)

            case let .view(.setTrainingToDelete(training)):
                state.trainingToDelete = training
                return .send(.presentConfirmation)
            
            case .presentConfirmation:
                state.destination = .confirmationDialog(
                    AlertState {
                        TextState("Warning")
                    } actions: {
                        ButtonState(role: .destructive, action: .delete) {
                            TextState("Delete")
                        }
                    } message: {
                        TextState("Do you want to delete this training?")
                    }
                )
            case .destination(.presented(.confirmationDialog(.delete))):
                guard let trainingToDelete = state.trainingToDelete else {
                    return .none
                }
                return .send(.delete(trainingToDelete.id))

            case let .delete(id):
                return .run { send in
                    await send(
                        .deleteDidFinish(
                            TaskResult {
                                await trainingClient.deleteTraining(id)
                                return .finished
                            }
                        )
                    )
                }

            case .deleteDidFinish(.success(.finished)):
                return .send(.fetchTrainings)

            case let .view(.edit(id)):
                guard let training = state.trainings.first (where: { $0.id == id }) else {
                    return .none
                }
                state.destination = .trainingForm(
                    TrainingFormFeature.State(
                        id: training.id,
                        date: training.date,
                        exercise: training.exercise,
                        result: training.result
                    )
                )

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
