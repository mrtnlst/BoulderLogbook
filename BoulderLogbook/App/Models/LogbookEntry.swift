//
//  LogbookEntry.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct LogbookEntry: Identifiable, Codable, Equatable {
    var id: String
    var date: Date
    var tops: [BoulderGrade]
}


extension LogbookEntry {
    static func logbookEntry(from data: LogbookData.Entry) -> Self {
        LogbookEntry(
            id: UUID().uuidString,
            date: data.date,
            tops: data.tops
        )
    }
}
