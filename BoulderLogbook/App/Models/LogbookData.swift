//
//  LogbookData.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct LogbookData: Codable, Equatable {
    var logbookEntries: [EntryData]
}

extension LogbookData {
    func toLogbook() -> Logbook {
        let dictionary = logbookEntries.reduce(into: [Date: [EntryData]]()) { partialResult, entry in
            if let sectionDate = entry.date.yearMonthDate {
                let existing = partialResult[sectionDate] ?? []
                partialResult[sectionDate] = existing + [entry]
            }
        }
        return Logbook(
            sections: dictionary.keys.map { sectionDate in 
                let entries = dictionary[sectionDate] ?? []
                return Logbook.Section(
                    date: sectionDate,
                    entries: entries.map {
                        Logbook.Entry(
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
