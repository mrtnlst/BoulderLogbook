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
        
        init(id: UUID = UUID(), name: String = "", color: Color = .mandalaBlue, difficulty: Int = 0) {
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

extension GradeSystem.Grade {
    static let mandalaBlue = GradeSystem.Grade(
        id: UUID(uuidString: "1BD4D89B-3319-423D-A9AE-E82DE8F30B65")!,
        name: "Blue",
        color: .mandalaBlue,
        difficulty: 0
    )
    static let mandalaRed = GradeSystem.Grade(
        id: UUID(uuidString: "B1AD6062-E220-48F9-8673-2EEB0230C987")!,
        name: "Red",
        color: .mandalaRed,
        difficulty: 1
    )
    static let mandalaOrange = GradeSystem.Grade(
        id: UUID(uuidString: "74896B7C-1A9C-467E-8851-C8EA6883A0B9")!,
        name: "Orange",
        color: .mandalaOrange,
        difficulty: 2
    )
    static let mandalaBlack = GradeSystem.Grade(
        id: UUID(uuidString: "51FBD95E-0BAB-479B-A746-4584B9F67276")!,
        name: "Black",
        color: .mandalaBlack,
        difficulty: 3
    )
    static let mandalaWhite = GradeSystem.Grade(
        id: UUID(uuidString: "52492AC4-3E61-484C-9183-A23E18674827")!,
        name: "White",
        color: .mandalaWhite,
        difficulty: 4
    )
    static let mandalaYellow = GradeSystem.Grade(
        id: UUID(uuidString: "C7E0D3BD-F890-49E2-826C-3119CF568BBA")!,
        name: "Yellow",
        color: .mandalaYellow,
        difficulty: 5
    )
    static let mandalaPurple = GradeSystem.Grade(
        id: UUID(uuidString: "7E551D9F-5748-49B5-8F8E-A9D601E51803")!,
        name: "Purple",
        color: .mandalaPurple,
        difficulty: 6
    )
}
