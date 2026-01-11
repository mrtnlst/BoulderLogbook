//
//  Exercise.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import Foundation

struct Exercise: Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let symbol: String
}

extension Exercise {
    static let deadHang = Exercise(
        id: UUID(),
        name: "Dead Hang",
        symbol: "figure.play"
    )
    static let pullUp = Exercise(
        id: UUID(),
        name: "Pull-up",
        symbol: "figure.play"
    )
    static let sitUp = Exercise(
        id: UUID(),
        name: "Sit-up",
        symbol: "figure.core.training"
    )
}
