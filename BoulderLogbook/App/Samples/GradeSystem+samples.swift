//
//  GradeSystem+samples.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.04.26.
//

import Foundation

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
    
    static let mandala2: GradeSystem = GradeSystem(
        id: UUID(uuidString: "22222222-ED9E-4224-ADC6-3DEF6D067D13")!,
        name: "Mandala 2",
        grades: [
            .mandala1,
            .mandala2,
            .mandala3,
            .mandala4,
            .mandala5,
            .mandala6,
            .mandala7,
            .mandala8
        ]
    )
}
