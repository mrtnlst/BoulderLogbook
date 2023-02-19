//
//  SessionDiagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.02.23.
//

import Foundation
import ComposableArchitecture

struct SessionDiagram: ReducerProtocol {
    struct State: Equatable {
        var entries: [Logbook.Section.Entry]
        var months: [Month] = []
        
        init(
            entries: [Logbook.Section.Entry] = [],
            calendar: Calendar = Calendar.current
        ) {
            self.entries = entries
            self.months = monthRangesOfPastYear(using: calendar).map { monthRange in
                let sessionCount = entries.filter { monthRange.contains($0.date) }.count
                let monthIndex = calendar.component(.month, from: monthRange.lowerBound) - 1
                let monthSymbol = calendar.shortMonthSymbols[monthIndex]
                let month = Month(date: monthSymbol, count: sessionCount)
                return month
            }
        }
    }
    struct Month: Equatable, Identifiable {
        let id: UUID = UUID()
        let date: String
        var count: Int
    }
            
    enum Action: Equatable {}
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {}
}

extension SessionDiagram.State {
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
