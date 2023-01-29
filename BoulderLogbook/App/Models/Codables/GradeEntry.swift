//
//  GradeEntry.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation

struct GradeEntry: Codable {
    let gradeSystem: GradeSystem
    let grade: GradeSystem.Grade
    let isAttempt: Bool
    let wasFlash: Bool
    let wasOnsight: Bool
}
