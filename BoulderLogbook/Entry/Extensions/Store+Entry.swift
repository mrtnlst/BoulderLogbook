//
//  Store+Entry.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import Foundation
import ComposableArchitecture

extension Store: Equatable where State == EntryState, Action == EntryAction {
    public static func == (
        lhs: ComposableArchitecture.Store<State, Action>,
        rhs: ComposableArchitecture.Store<State, Action>
    ) -> Bool {
        ViewStore(lhs).id == ViewStore(rhs).id
    }
}

extension Store: Hashable where State == EntryState, Action == EntryAction {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ViewStore(self).id)
        hasher.combine(ViewStore(self).entry)
    }
}
