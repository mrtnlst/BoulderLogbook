//
//  SummaryState.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation

struct SummaryState: Equatable {
    var logbook: Logbook
    
    init(logbook: Logbook = Logbook(logbookSections: [])) {
        self.logbook = logbook
    }
}
