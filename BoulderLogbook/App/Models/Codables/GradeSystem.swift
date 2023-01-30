//
//  GradeSystem.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import SwiftUI

struct GradeSystem: Equatable, Codable, Identifiable {
    struct Grade: Equatable, Codable, Identifiable {
        let id: UUID
        var name: String
        var color: Color
        var difficulty: Int
        
        init(id: UUID = UUID(), name: String = "", color: Color = .blue, difficulty: Int = 0) {
            self.id = id
            self.name = name
            self.color = color
            self.difficulty = difficulty
        }
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
