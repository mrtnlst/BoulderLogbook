//
//  SummaryEnvironment.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import CombineSchedulers
import ComposableArchitecture

struct SummaryEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var fetch: () -> Effect<Logbook, Never>
    var delete: (Logbook.Entry) -> Effect<Never, Never>
    var fetchFilters: () -> Effect<[BoulderGrade], Never>
}
