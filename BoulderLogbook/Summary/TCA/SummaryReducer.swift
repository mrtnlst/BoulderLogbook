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
        
        let dictionary = logbook.logbookEntries.reduce(into: [Date: [LogbookEntry]](), { partialResult, entry in
            let components = Calendar.current.dateComponents([.year, .month], from: entry.date)
            let date = Calendar.current.date(from: components)!
            let existing = partialResult[date] ?? []
            partialResult[date] = existing + [entry]
        })
        state.summarySections = .init(
            uniqueElements: dictionary.keys.map { date in
                let entries = dictionary[date] ?? []
                return SummarySectionState(
                    date: date,
                    summaryDetails: .init(uniqueElements: entries.map { SummaryDetailState(logbookEntry: $0) })
                )
            }
        )
        
        return .none
        
    case let .summarySectionAction(id: _, action: .delete(logbookEntry)) ,
        let .summarySectionAction(id: _, action:.summaryDetailAction(id: _, action: .delete(logbookEntry))):
        return .merge(
            environment
                .delete(logbookEntry)
                .fireAndForget(),
            Effect(value: .fetch)
        )
        
    case .summarySectionAction(id: _, action: _):
        return .none
    }
}
