//
//  SummaryState.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import IdentifiedCollections

struct SummaryState: Equatable {
    var logbook: Logbook
    
    init(logbook: Logbook = Logbook(logbookEntries: [])) {
        self.logbook = logbook
    }
}

extension SummaryState {
    var summaryDetails: IdentifiedArrayOf<SummaryDetailState> {
        .init(uniqueElements: logbook.logbookEntries.map { SummaryDetailState(logbookEntry: $0) })
    }
}
