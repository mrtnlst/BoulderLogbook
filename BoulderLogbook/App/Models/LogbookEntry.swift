//
//  LogbookEntry.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct LogbookEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    var tops: [BoulderGrade]
}

extension LogbookEntry {
    func numberOfGrades(for grade: BoulderGrade) -> Int {
        let dictionary = tops.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        return dictionary[grade] ?? 0
    }
}

let exampleLogbook: Logbook = Logbook(
    logbookSections: [
        LogbookSection(
            date: .now,
            logbookEntries: [
                LogbookEntry(
                    id: UUID(),
                    date: .now,
                    tops: [.white, .white, .black, .black, .black]
                ),
                LogbookEntry(
                    id: UUID(),
                    date: .now,
                    tops: [.white, .black, .red, .red, .red, .blue]
                )
            ]
        ),
        LogbookSection(
            date: Date(timeIntervalSinceNow: -86400),
            logbookEntries: [
                LogbookEntry(
                    id: UUID(),
                    date: Date(timeIntervalSinceNow: -86400),
                    tops: [.white, .black, .black, .black, .black]
                )
            ]
        ),
        LogbookSection(
            date: Date(timeIntervalSinceNow: -86400 * 2),
            logbookEntries: [
                LogbookEntry(
                    id: UUID(),
                    date: Date(timeIntervalSinceNow: -86400 * 2),
                    tops: [.black, .black, .black, .orange, .orange]
                )
            ]
        )
    ]
)
