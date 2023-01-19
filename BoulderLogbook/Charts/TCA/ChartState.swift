//
//  ChartState.swift
//  BoulderLogbook
//
//  Created by martin on 23.07.22.
//

import Foundation
import SwiftUI

struct ChartState: Equatable {
    var entries: [Logbook.Entry] = []
    var filters: [BoulderGrade] = BoulderGrade.allCases
    var selectedSegment: Segment = .week
    
    init(entries: [Logbook.Entry] = []) {
        self.entries = entries
    }
}

extension ChartState {
    var availableSegments: [Segment] {
        if entries.count <= Segment.week.tag {
            return [.week]
        } else if entries.count <= Segment.month.tag {
            return [.week, .month]
        } else {
            return [.week, .month, .all]
        }
    }
    
    var maximumValue: Int {
        let values = chartSections.map { $0.count }
        return values.max() ?? 0
    }
    
    var hasXAxisValueLabel: Bool {
        selectedSegment == .week
    }
}

extension ChartState {
    var chartSections: [ChartEntry] {
        return entries.prefix(selectedSegment.tag).reduce(into: []) { partialResult, entry in
            partialResult.append(
                contentsOf: BoulderGrade.allCases.compactMap { grade in
                    guard filters.contains(grade) else {
                        return nil
                    }
                    let count = entry.numberOfGrades(for: grade)
                    if count > 0 {
                        return ChartEntry(
                            grade: grade,
                            date: entry.date.dayMonthDateString ?? "",
                            count: count
                        )
                    }
                    return nil
                }
            )
        }
    }
}
