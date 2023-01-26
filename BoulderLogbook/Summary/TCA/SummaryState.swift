//
//  SummaryState.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import IdentifiedCollections

struct SummaryState: Equatable {
    var sections: IdentifiedArrayOf<SummarySection.State> = []
    var chartState: ChartState = ChartState()
}

extension SummaryState {
    /// Warning: Only used for previews!
    init(_ logbook: Logbook) {
        self.sections = .init(
            uniqueElements: logbook.sections.map {
                SummarySection.State($0)
            }
        )
    }
    
    var entryStates: [EntryDetail.State] {
        sections.reduce(into: []) { partialResult, sectionState in
            partialResult.append(contentsOf: sectionState.entryStates.elements)
        }
    }
}
