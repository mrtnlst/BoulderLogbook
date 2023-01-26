//
//  Dashboard.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct Dashboard: ReducerProtocol {
    struct State: Equatable {
        var sections: IdentifiedArrayOf<DashboardSection.State> = []
        var diagramState: Diagram.State = Diagram.State()
    }
    
    enum Action: Equatable {
        case onAppear
        case fetch
        case fetchFilters
        case receiveLogbookEntries(result: Result<Logbook, Never>)
        case dashboardSection(id: Double, action: DashboardSection.Action)
        case receiveFilters(Result<[BoulderGrade], Never>)
        case diagram(Diagram.Action)
        case presentFilters
    }
    
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.storageService) var storageService

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.diagramState, action: /Action.diagram) {
            Diagram()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    Effect(value: .fetch),
                    Effect(value: .fetchFilters)
                )
                
            case .fetch:
                return storageService
                    .fetch()
                    .receive(on: mainQueue)
                    .catchToEffect(Action.receiveLogbookEntries)
                
            case .fetchFilters:
                return storageService
                    .fetchFilters()
                    .receive(on: mainQueue)
                    .catchToEffect(Action.receiveFilters)
                
            case let .receiveLogbookEntries(result: .success(logbook)):
                state.sections = .init(
                    uniqueElements: logbook.sections.map { section in
                        DashboardSection.State(
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
                
            case let .dashboardSection(id: _, action: .delete(logbookEntry)) ,
                let .dashboardSection(id: _, action:.entryDetail(id: _, action: .delete(logbookEntry))):
                return .merge(
                    storageService
                        .delete(logbookEntry: logbookEntry)
                        .fireAndForget(),
                    Effect(value: .fetch)
                )
                
            case .dashboardSection(id: _, action: _):
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
    }
}

extension Dashboard.State {
    /// Warning: Only used for previews!
    init(_ logbook: Logbook) {
        self.sections = .init(
            uniqueElements: logbook.sections.map {
                DashboardSection.State($0)
            }
        )
    }
    
    var entryStates: [EntryDetail.State] {
        sections.reduce(into: []) { partialResult, sectionState in
            partialResult.append(contentsOf: sectionState.entryStates.elements)
        }
    }
}
