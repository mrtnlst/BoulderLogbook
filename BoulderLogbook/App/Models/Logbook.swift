//
//  LogbookData.swift
//  BoulderLogbook
//
//  Created by martin on 13.08.22.
//

import Foundation

public struct Logbook: Equatable {
    var sections: [Logbook.Section]
    
    public struct Section: Equatable {
        var date: Date
        var entries: [Entry]
        
        public struct Entry: Identifiable, Equatable, Hashable {
            public var id: String
            var date: Date
            var tops: [LegacyBoulderGrade]
            
            init(id: String = UUID().uuidString, date: Date, tops: [LegacyBoulderGrade]) {
                self.id = id
                self.date = date
                self.tops = tops
            }
        }
    }
}

extension Logbook.Section.Entry {
    var sectionDate: Date {
        date.yearMonthDate ?? date
    }
    
    var entryDate: Date {
        date.yearMonthDayDate ?? date
    }
}
