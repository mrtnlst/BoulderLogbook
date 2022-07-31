//
//  ChartState.swift
//  BoulderLogbook
//
//  Created by martin on 23.07.22.
//

import Foundation

struct ChartState: Equatable {
    enum Segment: Int {
        case week = 7
        case month = 30
        case all = 100
    }
    let logbook: Logbook
    var selectedSegment: Segment = .week
}

extension ChartState {
    struct BarChartEntry: Identifiable {
        let id: UUID = UUID()
        var grade: BoulderGrade
        var date: String
        var count: Int
    }
    
    var chartSections: [BarChartEntry] {
        return logbook.logbookEntries.prefix(selectedSegment.rawValue).reduce(into: []) { partialResult, entry in
            partialResult.append(
                contentsOf: BoulderGrade.allCases.map { grade in
                    BarChartEntry(
                        grade: grade,
                        date: entry.entryDateString,
                        count: entry.numberOfGrades(for: grade)
                    )
                }
            )
        }
    }
}
