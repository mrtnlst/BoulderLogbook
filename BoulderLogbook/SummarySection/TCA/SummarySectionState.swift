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
    var summaryDetails: IdentifiedArrayOf<SummaryDetailState> = []
}

extension SummarySectionState: Identifiable {
    var id: Double { date.timeIntervalSince1970 }
}
