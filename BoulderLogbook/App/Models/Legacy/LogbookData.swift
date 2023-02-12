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
                        Logbook.Section.Entry(
                            id: UUID(uuidString: $0.id)!,
                            date: $0.date,
                            tops: $0.tops.map { top in
                                Top(
                                    grade: UUID(), // FIXME!
                                    isAttempt: false,
                                    wasFlash: false,
                                    wasOnsight: false
                                )
                            },
                            gradeSystem: GradeSystem.mandala.id
                        )
                    }
                )
            }
        )
    }
    
    func toLogbookEntries() -> [Logbook.Section.Entry] {
        return logbookEntries.map { logbookDataEntry in
            let tops = logbookDataEntry.tops.map { grade in
                Top(
                    id: UUID(),
                    grade: grade.grade.id,
                    isAttempt: false,
                    wasFlash: false,
                    wasOnsight: false
                )
            }
            
            return Logbook.Section.Entry(
                id: UUID(uuidString: logbookDataEntry.id)!,
                date: logbookDataEntry.date,
                tops: tops,
                gradeSystem: GradeSystem.mandala.id
            )
        }
    }
}
