//
//  SummaryReducer.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import ComposableArchitecture

let summaryReducer = Reducer<SummaryState, SummaryAction, SummaryEnvironment>.combine(
    AnyReducer { Diagram() }.pullback(
        state: \.diagramState,
        action: /SummaryAction.diagram,
        environment: { _ in }
    ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
            return .merge(
                Effect(value: .fetch),
                Effect(value: .fetchFilters)
            )
            
        case .fetch:
            return environment
                .fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(SummaryAction.receiveLogbookEntries)
            
        case .fetchFilters:
            return environment
                .fetchFilters()
                .receive(on: environment.mainQueue)
                .catchToEffect(SummaryAction.receiveFilters)
            
        case let .receiveLogbookEntries(result: .success(logbook)):
            state.sections = .init(
                uniqueElements: logbook.sections.map { section in
                    SummarySection.State(
                        date: section.date,
                        entryStates: .init(
                            uniqueElements: section.entries.map {
                                EntryDetail.State(entry: $0)
                            }.sorted(
                                by: { $0.entry.date > $1.entry.date }
                            )
                        )
                    )
                }.sorted(
                    by: { $0.date > $1.date }
                )
            )
            let entries = state.entryStates.map {
                Logbook.Entry(date: $0.entry.date, tops: $0.entry.tops)
            }
            state.diagramState.entries = entries
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
            
        case let .receiveFilters(.success(filters)):
            state.diagramState.filters = filters
            return .none
            
        case .diagram(_):
            return .none
            
        case .presentFilters:
            return .none
        }
    }
)
