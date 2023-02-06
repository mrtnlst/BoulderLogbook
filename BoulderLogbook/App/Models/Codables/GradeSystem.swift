//
//  GradeSystem.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import SwiftUI

struct GradeSystem: Equatable, Codable, Identifiable, Hashable {
    struct Grade: Equatable, Codable, Identifiable, Hashable {
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

extension GradeSystem {
    static let mandala: GradeSystem = GradeSystem(
        id: UUID(),
        name: "Mandala",
        grades: [
            .mandalaBlue,
            .mandalaRed,
            .mandalaOrange,
            .mandalaBlack,
            .mandalaWhite,
            .mandalaYellow,
            .mandalaPurple
        ]
    )

    static let kletterarena: GradeSystem = GradeSystem(
        id: UUID(),
        name: "Kletterarena",
        grades: []
    )

}

extension GradeSystem.Grade {
    static let mandalaBlue = GradeSystem.Grade(
        name: "Blue",
        color: .mandalaBlue,
        difficulty: 0
    )
    static let mandalaRed = GradeSystem.Grade(
        name: "Red",
        color: .mandalaRed,
        difficulty: 1
    )
    static let mandalaOrange = GradeSystem.Grade(
        name: "Orange",
        color: .mandalaOrange,
        difficulty: 2
    )
    static let mandalaBlack = GradeSystem.Grade(
        name: "Black",
        color: .mandalaBlack,
        difficulty: 3
    )
    static let mandalaWhite = GradeSystem.Grade(
        name: "White",
        color: .mandalaWhite,
        difficulty: 4
    )
    static let mandalaYellow = GradeSystem.Grade(
        name: "Yellow",
        color: .mandalaYellow,
        difficulty: 5
    )
    static let mandalaPurple = GradeSystem.Grade(
        name: "Purple",
        color: .mandalaPurple,
        difficulty: 6
    )
}
