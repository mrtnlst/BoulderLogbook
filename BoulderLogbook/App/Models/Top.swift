//
//  Top.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation

struct Top: Codable, Equatable, Identifiable, Hashable {
    let id: UUID
    let grade: UUID
    let isAttempt: Bool
    let wasFlash: Bool
    let wasOnsight: Bool
    
    init(
        id: UUID = UUID(),
        grade: UUID = UUID(),
        isAttempt: Bool = false,
        wasFlash: Bool = false,
        wasOnsight: Bool = false
    ) {
        self.id = id
        self.grade = grade
        self.isAttempt = isAttempt
        self.wasFlash = wasFlash
        self.wasOnsight = wasOnsight
    }
}

extension [Top] {
    func count(for grade: Grade) -> Int {
        return self.filter { $0.grade == grade.id }.count
    }
    
    func successful() -> [Top] {
        return self.filter { !$0.isAttempt }
    }
    
    func normal() -> [Top] {
        return self.filter { !$0.isAttempt && !$0.wasFlash && !$0.wasOnsight }
    }
    
    func grades(for system: GradeSystem?) -> [Grade] {
        return self.map { $0.grade }.compactMap { gradeId in
            system?.grades.first(where: { $0.id == gradeId }) ?? nil
        }
    }
}

extension Top {
    static let sample1 = Top(grade: Grade.mandalaBlue.id)
    static let sample2 = Top(grade: Grade.mandalaRed.id)
    static let sample3 = Top(grade: Grade.mandalaOrange.id)
    static let sample4 = Top(grade: Grade.mandalaBlack.id)
    static let sample5 = Top(grade: Grade.mandalaWhite.id)
    static let sample6 = Top(grade: Grade.mandalaYellow.id)
    static let sample7 = Top(grade: Grade.mandalaPurple.id)
}
