//
//  SummarySectionAction.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation

enum SummarySectionAction: Equatable {
    case delete(Logbook.Entry)
    case edit(Logbook.Entry)
    case entryAction(id: String, action: EntryDetail.Action)
}
