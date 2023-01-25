//
//  ChartReducer.swift
//  BoulderLogbook
//
//  Created by martin on 23.07.22.
//

import Foundation
import ComposableArchitecture

let chartReducer = Reducer<ChartState, ChartAction, ChartEnvironment> { state, action, _ in
    switch action {
    case let .didSelectSegment(segment):
        state.selectedSegment = segment
        return .none
    }
}
