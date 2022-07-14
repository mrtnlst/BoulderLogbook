//
//  SummaryDetailState.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import Foundation

public struct SummaryDetailState: Equatable, Identifiable {
    var logbookEntry: LogbookEntry
    public var id: UUID { logbookEntry.id }
}
