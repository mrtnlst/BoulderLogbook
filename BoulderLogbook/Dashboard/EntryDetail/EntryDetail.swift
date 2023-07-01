//
//  EntryDetail.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct EntryDetail: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id: UUID
        let entry: Logbook.Section.Entry
        var gradeSystem: GradeSystem
        
        init(
            entry: Logbook.Section.Entry,
            gradeSystem: GradeSystem
        ) {
            self.id = entry.id
            self.entry = entry
            self.gradeSystem = gradeSystem
        }
    }
    
    enum Action: Equatable {
        case delete(UUID)
        case edit(Logbook.Section.Entry)
    }
    @Dependency(\.dismiss) var dismiss

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .edit:
            return .run { _ in await dismiss() }
            
        default: ()
        }
        return .none
    }
}
