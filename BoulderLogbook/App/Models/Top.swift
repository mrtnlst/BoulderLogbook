//
//  Top.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation

struct Top {
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
    
    init(
        id: UUID = UUID(),
        grade: UUID = UUID(),
        ascendType: AscendType = .redPoint
    ) {
        self.id = id
        self.grade = grade
        self.isAttempt = ascendType == .attempt
        self.wasFlash = ascendType == .flash
        self.wasOnsight = ascendType == .onsight
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
    
    func highestGrade(for system: GradeSystem?) -> Grade? {
        successful()
            .map { $0.grade }
            .compactMap { gradeId in
                system?.grades.first(where: { $0.id == gradeId }) ?? nil
            }
            .sorted(by: { $0.difficulty > $1.difficulty })
            .first
    }
    
    func filter(for ascendType: AscendType) -> [Top] {
        self.filter {
            switch ascendType {
            case .redPoint:
                true
            case .flash:
                !$0.isAttempt && $0.wasFlash && !$0.wasOnsight
            case .onsight:
                !$0.isAttempt && !$0.wasFlash && $0.wasOnsight
            case .attempt:
                $0.isAttempt && !$0.wasFlash && !$0.wasOnsight
            }
        }
    }
}

extension Top: Sendable {}
extension Top: Identifiable {}
extension Top: Equatable {}
extension Top: Hashable {}
extension Top: Codable {}
