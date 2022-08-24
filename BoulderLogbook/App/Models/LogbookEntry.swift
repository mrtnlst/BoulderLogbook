//
//  LogbookEntry.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct LogbookEntry: Codable, Equatable {
    var date: Date
    var tops: [BoulderGrade]
}

extension LogbookEntry: Identifiable {
    var id: Int {
        date.hashValue
    }
}

extension LogbookEntry {
    static func logbookEntry(from data: LogbookData.Entry) -> Self {
        LogbookEntry(
            date: data.date,
            tops: data.tops
        )
    }
}
