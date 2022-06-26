//
//  SummaryReducer.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import ComposableArchitecture

let summaryReducer = Reducer<SummaryState, SummaryAction, SummaryEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
        return Effect(value: .fetch)
    
    case .fetch:
        return environment
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(SummaryAction.receiveLogbookEntries)
    
    case let .receiveLogbookEntries(result: .success(logbook)):
        state.logbook = logbook
        return .none
    }
}
