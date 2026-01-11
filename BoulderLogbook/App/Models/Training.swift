//
//  Training.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import Foundation

struct Training: Identifiable, Equatable {
    enum Result: Equatable {
        case repititions(Int)
        case duration(TimeInterval)
    }
    let id: UUID
    let date: Date
    let exercise: Exercise
    let result: Result
}
