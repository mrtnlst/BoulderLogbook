//
//  FilterSheetEnvironment.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import Foundation
import ComposableArchitecture

struct FilterSheetEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetch: (String) -> Effect<Bool, Never>
    var save: (Bool, String) -> Effect<Never, Never>
}
