//
//  SummarySectionState.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation
import IdentifiedCollections

struct SummarySectionState: Equatable, Identifiable {
    let id: UUID = UUID()
    let date: Date
    var summaryDetails: IdentifiedArrayOf<SummaryDetailState> = []
}
