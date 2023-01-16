//
//  SummarySectionAction.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation

enum SummarySectionAction: Equatable {
    case delete(LogbookData.Entry)
    case edit(LogbookData.Entry)
    case entryAction(id: String, action: EntryAction)
}
