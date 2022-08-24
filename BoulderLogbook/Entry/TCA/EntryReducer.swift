//
//  EntryReducer.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import Foundation
import ComposableArchitecture

let entryReducer = Reducer<EntryState, EntryAction, EntryEnvironment> { _, _, _ in
    return .none
}
