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
    case .onAppear:
        state.logbookEntry = LogbookEntry(
            id: UUID(),
            date: .now,
            tops: []
        )
        return .none
        
    case .cancel:
        return .none
        
    case .save:
        guard let entry = state.logbookEntry else {
            return .none
        }
        return environment
            .save(entry)
            .fireAndForget()
        
    case let .increase(grade):
        state.logbookEntry?.tops.append(grade)
        return .none
        
    case let .decrease(grade):
        if let index = state.logbookEntry?.tops.firstIndex(of: grade) {
            state.logbookEntry?.tops.remove(at: index)
        }
        return .none
    }
}
