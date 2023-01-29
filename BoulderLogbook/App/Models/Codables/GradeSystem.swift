//
//  GradeSystem.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import SwiftUI

struct GradeSystem: Equatable, Codable, Identifiable {
    struct Grade: Equatable, Codable {
        let name: String
        let color: Color
        let difficulty: Int
    }
    let id: UUID
    let name: String
    let grades: [Grade]
}

let mandalaGrades: GradeSystem = GradeSystem(
    id: UUID(),
    name: "Mandala",
    grades: [
        .init(
            name: "Blue",
            color: .mandalaBlue,
            difficulty: 0
        ),
        .init(
            name: "Red",
            color: .mandalaRed,
            difficulty: 1
        ),
        .init(
            name: "Orange",
            color: .mandalaOrange,
            difficulty: 2
        ),
        .init(
            name: "Black",
            color: .mandalaBlack,
            difficulty: 3
        ),
        .init(
            name: "White",
            color: .mandalaWhite,
            difficulty: 4
        ),
        .init(
            name: "Yellow",
            color: .mandalaYellow,
            difficulty: 5
        )
    ]
)

let kletterarenaGrades: GradeSystem = GradeSystem(
    id: UUID(),
    name: "Kletterarena",
    grades: []
)
