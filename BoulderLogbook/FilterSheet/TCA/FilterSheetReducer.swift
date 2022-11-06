//
//  FilterReducer.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import Foundation
import ComposableArchitecture

let filterSheetReducer = Reducer<FilterSheetState, FilterSheetAction, FilterSheetEnvironment>.combine(
    filterReducer.forEach(
        state: \FilterSheetState.filters,
        action: /FilterSheetAction.filter,
        environment: { FilterEnvironment(mainQueue: $0.mainQueue, fetch: $0.fetch, save: $0.save) }
    ),
    Reducer { _, _, _ in
        return .none
    }
)
