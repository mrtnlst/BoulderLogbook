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
}

extension SummaryState {
    init(_ logbook: LogbookData) {
        self.sections = .init(
            uniqueElements: logbook.sections.map {
                SummarySectionState($0)
            }
        )
    }
}
