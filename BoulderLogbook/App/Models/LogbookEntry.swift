//
//  LogbookEntry.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

public struct LogbookEntry: Codable, Identifiable, Equatable, Hashable {
    public let id: UUID
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
            from: Calendar.current.dateComponents([.year, .month], from: date)
        ) else {
            return date
        }
        return sectionDate
    }
    
    var entryDate: Date {
        guard let entryDate = Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month, .day], from: date)
        ) else {
            return date
        }
        return entryDate
    }
    
    func numberOfGrades(for grade: BoulderGrade) -> Int {
        let dictionary = tops.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        return dictionary[grade] ?? 0
    }
    
    var entryDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        return dateFormatter.string(from: entryDate)
    }
}

let exampleLogbook: Logbook = Logbook(
    logbookEntries: [
        LogbookEntry(
            date: .now,
            tops: [.purple, .purple, .white, .black, .black, .black, .black, .orange, .red, .red, .blue]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400),
            tops: [.white, .black, .red, .red, .red, .blue]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 2),
            tops: [.black, .black, .black, .orange, .orange]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 3),
            tops: [.white, .black, .orange, .orange, .red]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 4),
            tops: [.white, .white, .black, .black, .black, .orange]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 5),
            tops: [.white, .white, .white, .black, .black]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 6),
            tops: [.white, .black, .black, .black, .black, .black, .black, .orange, .orange, .orange]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 7),
            tops: [.white, .black, .black, .black, .orange, .orange, .orange, .red]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 8),
            tops: [.black, .black, .black, .black, .black, .orange, .orange, .blue, .blue]
        ),
        LogbookEntry(
            date: Date(timeIntervalSinceNow: -86400 * 9),
            tops: [.purple, .white, .black, .orange]
        )
    ]
)
