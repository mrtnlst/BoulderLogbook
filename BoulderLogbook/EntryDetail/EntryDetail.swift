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
        var entry: Logbook.Entry
        public var id: String { entry.id }
    }
    
    public enum Action: Equatable {
        case delete(Logbook.Entry)
        case edit(Logbook.Entry)
    }
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
    
}
