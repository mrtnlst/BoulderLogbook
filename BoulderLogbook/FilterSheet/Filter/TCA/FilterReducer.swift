//
//  FilterReducer.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import Foundation
import ComposableArchitecture

let filterReducer = Reducer<FilterState, FilterAction, FilterEnvironment> { state, action, environment in
    switch action {
    case .fetch:
        return environment
            .fetch(state.grade.gradeDescription)
            .receive(on: environment.mainQueue)
            .catchToEffect(FilterAction.receiveValue)
    
    case let .receiveValue(.success(value)):
        state.isOn = value
        return .none
        
    case let .setIsOn(isOn):
        state.isOn = isOn
        return environment
            .save(isOn, state.grade.gradeDescription)
            .fireAndForget()
    }
}
