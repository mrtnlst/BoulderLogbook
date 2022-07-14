//
//  Logbook.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct Logbook: Codable, Equatable {
    var logbookEntries: [LogbookEntry]
    
    init(logbookEntries: [LogbookEntry] = []) {
        self.logbookEntries = logbookEntries
    }
}
