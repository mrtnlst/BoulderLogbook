//
//  SessionInsightsFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SessionInsightsFeature {
    private enum EffectId {
        case taskEffect
    }

    @ObservableState
    struct State {
        @Shared internal var timeSegment: TimeSegment
        @Shared internal var entries: [Logbook.Section.Entry]
        var sessionCountInsight: InsightModel = .sessionCount()
        var mostCommonWeekdayInsight: InsightModel = .mostCommonWeekday()
        
        init(
            timeSegment: Shared<TimeSegment>,
            entries: Shared<[Logbook.Section.Entry]>
        ) {
            self._timeSegment = timeSegment
            self._entries = entries
        }
    }
    
    enum Action: ViewAction {
        enum View {
            case task
        }
        case didUpdateTimeSegment
        case didUpdateEntries
        case view(View)
    }

    @Dependency(\.calendar) var calendar
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.task):
                return .merge(
                    .publisher {
                        state.$timeSegment.publisher.map { _ in
                            Action.didUpdateTimeSegment
                        }
                    },
                    .publisher {
                        state.$entries.publisher.map { _ in
                            Action.didUpdateEntries
                        }
                    }
                )
                .cancellable(id: EffectId.taskEffect, cancelInFlight: true)
            
            case .didUpdateTimeSegment:
                updateSessionCountInsight(&state)
                
            case .didUpdateEntries:
                updateSessionCountInsight(&state)
                updateMostCommonWeekdayInsight(in: &state)
            }
            return .none
        }
    }
}

extension SessionInsightsFeature {
    func updateSessionCountInsight(_ state: inout SessionInsightsFeature.State) {
        var insightText: String = "You went to the gym %@ times %@."
        switch state.timeSegment {
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
        default:
            let segment = state.timeSegment
            let startDate = if let calendarComponent = state.timeSegment.calendarComponent { calendar.dateInterval(of: calendarComponent, for: .now)?.start ?? .now
            } else {
                Date.distantPast
            }
            let count = state.entries.count { $0.date > startDate }
            insightText = String(format: insightText, "\(count)", segment.description)
        }
        state.sessionCountInsight = .sessionCount(insight: insightText)
    }
    
    func updateMostCommonWeekdayInsight(
        in state: inout SessionInsightsFeature.State
    ) {
        let entriesPerWeekday = state.entries.reduce(into: [Int: Int]()) { partialResult, entry in
            let weekday = calendar.component(.weekday, from: entry.date)
            let numberOfEntries = partialResult[weekday] ?? 0
            partialResult[weekday] = numberOfEntries + 1
        }
        if let element = entriesPerWeekday.max(by: { $0.value < $1.value }),
           let weekday = DateFormatter().weekdaySymbols[safe: element.key - 1] {
            state.mostCommonWeekdayInsight = .mostCommonWeekday(
                insight: "Your most common day to workout is \(weekday) with \(element.value) times."
            )
        } else {
            state.mostCommonWeekdayInsight = .mostCommonWeekday(insight: "No data available!")
        }
    }
}
