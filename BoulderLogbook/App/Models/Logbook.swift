//
//  LogbookData.swift
//  BoulderLogbook
//
//  Created by martin on 13.08.22.
//

import Foundation

struct Logbook: Equatable {
    struct Section: Equatable {
        struct Entry: Identifiable, Equatable, Hashable, Codable {
            public let id: UUID
            var date: Date
            var tops: [Top]
            var gradeSystem: UUID
            
            init(
                id: UUID = UUID(),
                date: Date,
                tops: [Top] = [],
                gradeSystem: UUID
            ) {
                self.id = id
                self.date = date
                self.tops = tops
                self.gradeSystem = gradeSystem
            }
        }
        var date: Date
        var entries: [Entry]
    }
    var sections: [Section]
}

extension Logbook.Section.Entry {
    var sectionDate: Date {
        date.yearMonthDate ?? date
    }
    
    var entryDate: Date {
        date.yearMonthDayDate ?? date
    }
}
