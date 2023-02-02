//
//  DashboardSection.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct DashboardSection: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: Double { date.timeIntervalSince1970 }
        let date: Date
        var entryStates: IdentifiedArrayOf<EntryDetail.State> = []
    }
    
    enum Action: Equatable {
        case delete(Logbook.Section.Entry)
        case edit(Logbook.Section.Entry)
        case entryDetail(id: String, action: EntryDetail.Action)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}

extension DashboardSection.State {
    /// Warning: Only used for previews!
    init(_ section: Logbook.Section) {
        self.date = section.date
        self.entryStates = .init(
            uniqueElements: section.entries.map {
                EntryDetail.State(entry: $0)
            }
        )
    }
}
