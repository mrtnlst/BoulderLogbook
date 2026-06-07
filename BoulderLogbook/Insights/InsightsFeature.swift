//
//  InsightsFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.06.26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct InsightsFeature {
    enum TimeSegment: String, Hashable, CaseIterable {
        case month = "Month"
        case year = "Year"
        case all = "All time"
    }
    
    @ObservableState
    struct State {
        var selectedSegment: TimeSegment = .month
        var sessionCountViewState: ViewState<String, String> = .loading
        var mostCommonWeekdayViewState: ViewState<String, Never> = .loading
        internal var entries: [Logbook.Section.Entry] = []
    }
    
    enum Action: BindableAction, ViewAction {
        enum View {
            case task
        }
        case fetchEntries
        case receiveEntries(Result<[Logbook.Section.Entry], Never>)
        case binding(BindingAction<State>)
        case view(View)
    }
    
    @Dependency(\.calendar) var calendar
    @Dependency(\.logbookEntryClient) var entryClient

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .view(.task):
                return .run { send in
                    await send(.receiveEntries(Result { await entryClient.fetchEntries() }))
                }

            case let .receiveEntries(.success(entries)):
                state.entries = entries
                updateSessionInsight(in: &state)
                updateMostCommonWeekdayInsight(in: &state)
            
            case .binding(\.selectedSegment):
                updateSessionInsight(in: &state)

            default: ()
            }
            return .none
        }
    }
}

private extension InsightsFeature {
    func updateSessionInsight(
        in state: inout InsightsFeature.State
    ) {
        var insightText: String = "You went to the gym %@ times in %@."
        switch state.selectedSegment {
        case .month:
            let monthAgoCalendar = calendar.date(byAdding: .month, value: -1, to: .now) ?? .now
            let count = state.entries.count { $0.date > monthAgoCalendar }
            insightText = String(
                format: insightText,
                "\(count)",
                "the last \(state.selectedSegment.rawValue.lowercased())"
            )
        case .year:
            let yearAgoCalendar = calendar.date(byAdding: .year, value: -1, to: .now) ?? .now
            let count = state.entries.count { $0.date > yearAgoCalendar }
            insightText = String(
                format: insightText,
                "\(count)",
                "the last \(state.selectedSegment.rawValue.lowercased())"
            )
        case .all:
            // Displays number of years between oldest entry and now.
            // The entry's starting date is moved to the 1st of Jan.
            let oldestEntry = state.entries.min(by: { $0.date < $1.date })?.date ?? .now
            let oldestEntryComponents = calendar.dateComponents([.year], from: oldestEntry)
            let startingDate = calendar.date(from: oldestEntryComponents) ?? .now
            let components = calendar.dateComponents([.year], from: startingDate, to: .now)
            insightText = String(
                format: insightText,
                "\(state.entries.count)",
                "over the last \(components.year ?? 0) years"
            )
        }
        state.sessionCountViewState = .idle(insightText)
    }
    
    func updateMostCommonWeekdayInsight(
        in state: inout InsightsFeature.State
    ) {
        let entriesPerWeekday = state.entries.reduce(into: [Int: Int]()) { partialResult, entry in
            let weekday = calendar.component(.weekday, from: entry.date)
            let numberOfEntries = partialResult[weekday] ?? 0
            partialResult[weekday] = numberOfEntries + 1
        }
        if let element = entriesPerWeekday.max(by: { $0.value < $1.value }),
           let weekday = DateFormatter().weekdaySymbols[safe: element.key - 1] {
            state.mostCommonWeekdayViewState = .idle(
                "Your most common day to workout is \(weekday) with \(element.value) times."
            )
        }
    }
}
