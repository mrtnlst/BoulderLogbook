//
//  SummarySectionAction.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation

enum SummarySectionAction: Equatable {
    case delete(LogbookEntry)
    case edit(LogbookEntry)
    case summaryDetailAction(id: UUID, action: SummaryDetailAction)
}
