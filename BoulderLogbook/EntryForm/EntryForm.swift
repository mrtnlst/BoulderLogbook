//
//  EntryForm.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct EntryForm: ReducerProtocol {
    struct State: Equatable {
        var entry: Logbook.Entry
        let isNewEntry: Bool
        
        init(entry: Logbook.Entry = Logbook.Entry(date: .now, tops: []), isNewEntry: Bool = true) {
            self.entry = entry
            self.isNewEntry = isNewEntry
        }
    }
    
    enum Action {
        case cancel
        case save
        case increase(LegacyBoulderGrade)
        case decrease(LegacyBoulderGrade)
        case didSelectDate(Date)
    }
    
    @Dependency(\.storageService) var storageService
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .cancel:
            return .none
            
        case .save:
            return .fireAndForget { [state] in
                storageService.save(state.entry)
            }

        case let .increase(grade):
            state.entry.tops.append(grade)
            return .none
            
        case let .decrease(grade):
            if let index = state.entry.tops.firstIndex(of: grade) {
                state.entry.tops.remove(at: index)
            }
            return .none
        
        case let .didSelectDate(date):
            state.entry.date = date
            return .none
        }
    }
}
