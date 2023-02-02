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
        var id: String
        @BindingState var date: Date
        var tops: [LegacyBoulderGrade]
        
        init(
            id: String = UUID().uuidString,
            date: Date = .now,
            tops: [LegacyBoulderGrade] = []
        ) {
            self.id = id
            self.date = date
            self.tops = tops
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case save
        case cancel
        case increase(LegacyBoulderGrade)
        case decrease(LegacyBoulderGrade)
    }
    
    @Dependency(\.storageService) var storageService
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .save:
                let entry = Logbook.Section.Entry(
                    id: state.id,
                    date: state.date,
                    tops: state.tops
                )
                return .fireAndForget { storageService.save(entry) }
                
            case let .increase(grade):
                state.tops.append(grade)
                return .none
                
            case let .decrease(grade):
                if let index = state.tops.firstIndex(of: grade) {
                    state.tops.remove(at: index)
                }
                return .none
                
            default:
                return .none
            }
        }
    }
}
