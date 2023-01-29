//
//  StoreOf+EntryDetail.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import Foundation
import ComposableArchitecture

extension StoreOf: Equatable where State == EntryDetail.State {
    public static func == (
        lhs: ComposableArchitecture.Store<State, Action>,
        rhs: ComposableArchitecture.Store<State, Action>) -> Bool {
            ViewStore(lhs).id == ViewStore(rhs).id && ViewStore(lhs).entry == ViewStore(rhs).entry
    }
}

extension StoreOf: Hashable where State == EntryDetail.State {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ViewStore(self).id)
        hasher.combine(ViewStore(self).entry)
    }
}
