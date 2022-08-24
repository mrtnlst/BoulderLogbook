//
//  FormReducer.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import ComposableArchitecture

let formReducer = Reducer<FormState, FormAction, FormEnvironment> { state, action, environment in
    switch action {
    case .cancel:
        return .none
        
    case .save:
        return environment
            .save(state.entry)
            .fireAndForget()
        
    case let .increase(grade):
        state.entry.tops.append(grade)
        return .none
        
    case let .decrease(grade):
        if let index = state.entry.tops.firstIndex(of: grade) {
            state.entry.tops.remove(at: index)
        }
        return .none
    
    case let .didSelectDate(date):
        state.entry.date = date
        return .none
    }
}
