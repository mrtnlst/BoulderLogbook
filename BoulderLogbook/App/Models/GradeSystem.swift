//
//  GradeSystem.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation

struct GradeSystem {
    let id: UUID
    let name: String
    let grades: [Grade]
}

extension GradeSystem: Sendable {}
extension GradeSystem: Equatable {}
extension GradeSystem: Codable {}
extension GradeSystem: Identifiable {}
extension GradeSystem: Hashable {}
