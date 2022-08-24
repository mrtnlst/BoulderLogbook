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
        state.sections = .init(
            uniqueElements: logbook.sections.map { section in
                SummarySectionState(
                    date: section.date,
                    entryStates: .init(
                        uniqueElements: section.entries.map {
                            EntryState(entry: $0)
                        }.sorted(
                            by: { $0.entry.date > $1.entry.date }
                        )
                    )
                )
            }.sorted(
                by: { $0.date > $1.date }
            )
        )
        
        return .none
        
    case let .summarySectionAction(id: _, action: .delete(logbookEntry)) ,
        let .summarySectionAction(id: _, action:.entryAction(id: _, action: .delete(logbookEntry))):
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
