//
//  LogbookEntry.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct LogbookEntry: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    var date: Date
    var tops: [BoulderGrade]
    
    internal init(id: UUID = UUID(), date: Date, tops: [BoulderGrade]) {
        self.id = id
        self.date = date
        self.tops = tops
    }
}

extension LogbookEntry {
    var sectionDate: Date {
        guard let sectionDate = Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month, .day], from: date)
        ) else {
            return date
        }
        return sectionDate
    }
    
    func numberOfGrades(for grade: BoulderGrade) -> Int {
        let dictionary = tops.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        return dictionary[grade] ?? 0
    }
}

let exampleLogbook: Logbook = Logbook(
    logbookEntries: [
        LogbookEntry(
//            id: UUID(),
            date: .now,
            tops: [.yellow,
                   .white, .white,
                   .black, .black, .black,
                   .orange, .orange, .orange, .orange, .orange,
                   .red, .red, .red, .red, .red, .red,
                   .blue, .blue, .blue, .blue, .blue
            ]
        ),
        LogbookEntry(
//            id: UUID(),
            date: Date(timeIntervalSinceNow: -86400),
            tops: [.white, .black, .red, .red, .red, .blue]
        ),
        LogbookEntry(
//            id: UUID(),
            date: Date(timeIntervalSinceNow: -86400 * 2),
            tops: [.black, .black, .black, .orange, .orange]
        ),
        LogbookEntry(
//            id: UUID(),
            date: Date(timeIntervalSinceNow: -86400 * 3),
            tops: [.white, .black, .orange, .orange, .red]
        ),
        LogbookEntry(
//            id: UUID(),
            date: Date(timeIntervalSinceNow: -86400 * 4),
            tops: [.white, .white, .black, .black, .black, .orange]
        ),
        LogbookEntry(
//            id: UUID(),
            date: Date(timeIntervalSinceNow: -86400 * 5),
            tops: [.white, .white, .white, .black, .black]
        ),
        LogbookEntry(
//            id: UUID(),
            date: Date(timeIntervalSinceNow: -86400 * 6),
            tops: [.white, .black, .black, .black, .black, .black, .black, .orange, .orange, .orange]
        )
    ]
)
