//
//  SessionDiagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.02.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SessionDiagram {
    @ObservableState
    struct State: Equatable {
        var viewState: ViewState<[Model], String> = .loading
    }
            
    enum Action: Equatable {
        case receiveEntries([Logbook.Section.Entry])
    }
    
    struct Model: Equatable, Identifiable {
        let id: UUID = UUID()
        let date: String
        var count: Int
    }
    
    @Dependency(\.calendar) var calendar
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .receiveEntries(entries):
            if entries.isEmpty {
                state.viewState = .error("No sessions available!")
            } else {
                let models = monthRangesOfPastYear(using: calendar).map { monthRange in
                    let sessionCount = entries.filter { monthRange.contains($0.date) }.count
                    let monthIndex = calendar.component(.month, from: monthRange.lowerBound) - 1
                    let monthSymbol = calendar.shortMonthSymbols[monthIndex]
                    return Model(date: monthSymbol, count: sessionCount)
                }
                state.viewState = .idle(models)
            }
        }
        return .none
    }
}

extension SessionDiagram {
    func monthRangesOfPastYear(using calendar: Calendar) -> [Range<Date>] {
        guard let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: .now) else {
            return []
        }
        let monthValues = Array(1...12)
        var monthDates: [Date] = []
        
        monthValues.forEach { month in
            // Create monthly dates from `oneYearAgo` as a start date and incrementing by `1`.
            if let date = calendar.date(byAdding: .month, value: month, to: oneYearAgo),
               // We need the start date to create date ranges.
               let startDate = calendar.dateInterval(of: .month, for: date)?.start {
                monthDates.append(startDate)
            }
        }
        var monthRanges: [Range<Date>] = []
        for (index, startDate) in monthDates.enumerated() {
            // Create end date for last date range.
            let endDate = index == monthDates.count - 1 ? .now : monthDates[index + 1]
            monthRanges.append(startDate..<endDate)
        }
        return monthRanges
    }
}
