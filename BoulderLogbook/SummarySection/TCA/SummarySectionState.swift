//
//  SummarySectionState.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation
import IdentifiedCollections

struct SummarySectionState: Equatable {
    let date: Date
    var entryStates: IdentifiedArrayOf<EntryState> = []
}

extension SummarySectionState: Identifiable {
    var id: Double { date.timeIntervalSince1970 }
}

extension SummarySectionState {
    init(_ section: Logbook.Section) {
        self.date = section.date
        self.entryStates = .init(
            uniqueElements: section.entries.map {
                EntryState(entry: $0)
            }
        )
    }
}
