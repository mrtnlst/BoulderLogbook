//
//  SummaryState.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import IdentifiedCollections

struct SummaryState: Equatable {
    var logbook: Logbook = Logbook(logbookEntries: [])
    var summarySections: IdentifiedArrayOf<SummarySectionState> = []
}
