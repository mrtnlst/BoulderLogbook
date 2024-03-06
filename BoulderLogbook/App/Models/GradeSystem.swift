//
//  GradeSystem.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import SwiftUI

struct GradeSystem: Equatable, Codable, Identifiable, Hashable {
    let id: UUID
    let name: String
    let grades: [Grade]
}

extension GradeSystem {
    static let mandala: GradeSystem = GradeSystem(
        id: UUID(uuidString: "724B7131-ED9E-4224-ADC6-3DEF6D067D13")!,
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
