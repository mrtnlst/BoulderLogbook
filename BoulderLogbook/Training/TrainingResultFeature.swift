//
//  TrainingResultFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 11.01.26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TrainingResultFeature {
    /// Hint: Not using ``Training/Result`` here as it has associated values.
    enum Segment: String, CaseIterable {
        case repititions = "Repititions"
        case duration = "Duration"
    }

    @ObservableState
    struct State: Equatable {
        var duration: TimeInterval
        var repititions: Int
        var selectedSegment: Segment = .repititions
        
        var selectedValue: Training.Result {
            switch selectedSegment {
            case .repititions:
                return .repititions(repititions)
            case .duration:
                return .duration(duration)
            }
        }
        
        init(
            result: Training.Result = .repititions(0)
        ) {
            switch result {
            case let .repititions(value):
                self.repititions = value
                self.duration = 0
            case let .duration(value):
                self.repititions = 0
                self.duration = value
            }
        }
    }
    
    enum Action {
        case didSelectSegment(Segment)
        case didChangeStepper(Int)
    }

    var body: some ReducerOf<TrainingResultFeature> {
        Reduce { state, action in
            switch action {
            case let .didSelectSegment(segment):
                state.selectedSegment = segment
                
            case let .didChangeStepper(count):
                state.repititions = count
            }
            return .none
        }
    }
}
