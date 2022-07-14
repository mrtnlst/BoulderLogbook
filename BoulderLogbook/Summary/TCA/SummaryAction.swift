//
//  SummaryAction.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation

enum SummaryAction: Equatable {
    case onAppear
    case fetch
    case receiveLogbookEntries(result: Result<Logbook, Never>)
    case delete(entry: IndexSet)
    case summaryDetailAction(id: UUID, action: SummaryDetailAction)
}
