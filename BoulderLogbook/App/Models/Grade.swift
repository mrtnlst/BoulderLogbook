//
//  Grade.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.02.24.
//

import SwiftUI

struct Grade {
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

extension Grade: Sendable {}
extension Grade: Equatable {}
extension Grade: Codable {}
extension Grade: Identifiable {}
extension Grade: Hashable {}
