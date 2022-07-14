//
//  Store+SummaryDetail.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import Foundation
import ComposableArchitecture

extension Store: Equatable where State == SummaryDetailState, Action == SummaryDetailAction {
    public static func == (
        lhs: ComposableArchitecture.Store<State, Action>,
        rhs: ComposableArchitecture.Store<State, Action>
    ) -> Bool {
        ViewStore(lhs).id == ViewStore(rhs).id
    }
}

extension Store: Hashable where State == SummaryDetailState, Action == SummaryDetailAction {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ViewStore(self).id)
        hasher.combine(ViewStore(self).logbookEntry)
    }
}
