//
//  FilterSheet.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.01.23.
//

import Foundation
import ComposableArchitecture

struct FilterSheet: ReducerProtocol {
    struct State: Equatable {
        var filters: IdentifiedArrayOf<Filter.State> = IdentifiedArray(
            uniqueElements: BoulderGrade.allCases.map {
                Filter.State(
                    grade: $0,
                    isOn: false
                )
            }
        )
    }
    
    enum Action {
        case filter(Filter.State.ID, Filter.Action)
    }
    
    var mainQueue: AnySchedulerOf<DispatchQueue> = .main
    var fetch: (String) -> Effect<Bool, Never>
    var save: (Bool, String) -> Effect<Never, Never>
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { _, _ in
            return .none
        }
        .forEach(\.filters, action: /Action.filter) {
            Filter(mainQueue: self.mainQueue, fetch: self.fetch, save: self.save)
        }
    }
}
