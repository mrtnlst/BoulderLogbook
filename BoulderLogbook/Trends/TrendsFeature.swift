//
//  TrendsFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 20.09.26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TrendsFeature {
    @ObservableState
    struct State {
        @Shared(.fileStorage(.focusGrade)) var focusedGrade: Grade?
        @Shared var sections: [Logbook.Section]
        
        var gymFrequency: TrendModel = .gymFrequency()
        var ascendsOfGrade: TrendModel = .ascendsOfGrade()
        
        init(sections: Shared<[Logbook.Section]>) {
            self._sections = sections
        }
    }
    
    enum Action: ViewAction {
        enum View {
            case task
        }
        case didUpdateSections
        case view(View)
    }

    @Dependency(\.calendar) var calendar

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.task):
                return .publisher {
                    state.$sections.publisher.map { _ in
                        Action.didUpdateSections
                    }
                }
                
            case .didUpdateSections:
                updateTrends(in: &state)
            }
            return .none
        }
    }
}

extension TrendsFeature {
    func updateTrends(in state: inout State) {
        let currentWeekStart = calendar.dateInterval(
            of: .weekOfYear,
            for: .now
        )?.start ?? .now
        let previousWeekStart = calendar.date(
            byAdding: .weekOfYear,
            value: -1,
            to: currentWeekStart
        ) ?? .now
        let entries = state.sections.reduce(into: [Logbook.Section.Entry]()) {
            $0.append(contentsOf: $1.entries)
        }
        let currentWeekEntries = entries.filter { $0.date > currentWeekStart }
        let previousWeekEntries = entries.filter {
            currentWeekStart > $0.date && $0.date > previousWeekStart
        }
        state.gymFrequency = .gymFrequency(
            trend: .init(
                currentCount: currentWeekEntries.count,
                previousCount: previousWeekEntries.count
            ),
            count: currentWeekEntries.count
        )
        state.ascendsOfGrade = ascendsOfGradeTrend(
            currentWeekEntries: currentWeekEntries,
            previousWeekEntries: previousWeekEntries,
            focusGrade: state.focusedGrade
        )
    }
    
    func ascendsOfGradeTrend(
        currentWeekEntries: [Logbook.Section.Entry],
        previousWeekEntries: [Logbook.Section.Entry],
        focusGrade: Grade?
    ) -> TrendModel {
        guard let focusGrade else {
            return .ascendsOfGrade()
        }
        let currentWeekAscends = currentWeekEntries.reduce(into: 0) {
            $0 += $1.tops.count(for: focusGrade)
        }
        let previousWeekAscends = previousWeekEntries.reduce(into: 0) {
            $0 += $1.tops.count(for: focusGrade)
        }
        return .ascendsOfGrade(
            category: "Ascends of \(focusGrade.name)",
            trend: .init(
                currentCount: currentWeekAscends,
                previousCount: previousWeekAscends
            ),
            count: currentWeekAscends
        )
    }
}
