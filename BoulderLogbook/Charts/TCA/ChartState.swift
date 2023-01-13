//
//  ChartState.swift
//  BoulderLogbook
//
//  Created by martin on 23.07.22.
//

import Foundation

struct ChartState: Equatable {
    let entries: [LogbookData.Entry]
    var selectedSegment: Segment = .week
    
    init(_ entries: [EntryState]) {
        self.entries = entries.map {
            LogbookData.Entry(id: $0.entry.id, date: $0.entry.date, tops: $0.entry.tops)
        }
    }
    
    init(entries: [LogbookData.Entry]) {
        self.entries = entries
    }
}

extension ChartState {
    var availableSegments: [Segment] {
        if entries.count <= Segment.week.tag {
            return []
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
    
    var hasPicker: Bool {
        availableSegments.count > 0
    }
}

extension ChartState {
    var chartSections: [ChartEntry] {
        return entries.prefix(selectedSegment.tag).reduce(into: []) { partialResult, entry in
            partialResult.append(
                contentsOf: BoulderGrade.allCases.compactMap { grade in
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
