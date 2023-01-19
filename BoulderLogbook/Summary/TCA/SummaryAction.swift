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
    case fetchFilters
    case receiveLogbookEntries(result: Result<Logbook, Never>)
    case summarySectionAction(id: Double, action: SummarySectionAction)
    case receiveFilters(Result<[BoulderGrade], Never>)
    case chart(ChartAction)
}
