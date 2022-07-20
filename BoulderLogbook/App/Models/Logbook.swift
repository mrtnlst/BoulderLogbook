//
//  Logbook.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct Logbook: Codable, Equatable {
    var logbookEntries: [LogbookEntry]
    
    init(logbookEntries: [LogbookEntry] = []) {
        self.logbookEntries = logbookEntries
    }
}

extension Logbook {
    struct BarChartEntry: Identifiable {
        let id: UUID = UUID()
        var grade: BoulderGrade
        var date: String
        var count: Int
    }
    
    var chartSections: [BarChartEntry] {
        return logbookEntries.reduce(into: []) { partialResult, entry in
            partialResult.append(
                contentsOf: BoulderGrade.allCases.map { grade in
                    BarChartEntry(
                        grade: grade,
                        date: entry.sectionDateString,
                        count: entry.numberOfGrades(for: grade)
                    )
                }
            )
        }
    }
}
