//
//  SummaryState.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import IdentifiedCollections

struct SummaryState: Equatable {
    var sections: IdentifiedArrayOf<SummarySectionState> = []
    var chartState: ChartState = ChartState()
}

extension SummaryState {
    init(_ logbook: Logbook) {
        self.sections = .init(
            uniqueElements: logbook.sections.map {
                SummarySectionState($0)
            }
        )
    }
    
    var entryStates: [EntryState] {
        sections.reduce(into: []) { partialResult, sectionState in
            partialResult.append(contentsOf: sectionState.entryStates.elements)
        }
    }
}
