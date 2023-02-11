//
//  EntryDetail.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

public struct EntryDetail: Equatable, ReducerProtocol {
    public struct State: Equatable, Identifiable {
        public let id: UUID
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
    
    public enum Action: Equatable {
        case delete(UUID)
        case edit(Logbook.Section.Entry)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}
