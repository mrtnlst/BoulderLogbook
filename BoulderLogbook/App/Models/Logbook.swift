//
//  Logbook.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct Logbook: Codable, Equatable {
    var logbookEntries: [LogbookEntry]
}

extension Logbook {
    func toLogbookData() -> LogbookData {
        let dictionary = logbookEntries.reduce(into: [Date: [LogbookEntry]]()) { partialResult, entry in
            if let sectionDate = entry.date.yearMonthDate {
                let existing = partialResult[sectionDate] ?? []
                partialResult[sectionDate] = existing + [entry]
            }
        }
        return LogbookData(
            sections: dictionary.keys.map { sectionDate in 
                let entries = dictionary[sectionDate] ?? []
                return LogbookData.Section(
                    date: sectionDate,
                    entries: entries.map {
                        LogbookData.Entry(
                            id: $0.id,
                            date: $0.date,
                            tops: $0.tops
                        )
                    }
                )
            }
        )
    }
}
