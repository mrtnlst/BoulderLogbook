//
//  LogbookSection.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.06.22.
//

import Foundation

struct LogbookSection: Codable, Equatable, Identifiable {
    let id: UUID
    var date: Date
    var logbookEntries: [LogbookEntry]
    
    init(id: UUID = UUID(), date: Date, logbookEntries: [LogbookEntry]) {
        self.id = id
        self.date = date
        self.logbookEntries = logbookEntries
    }
}
