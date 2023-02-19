//
//  Logbook+backup.swift
//  BoulderLogbook
//
//  Created by Martin List on 19.02.23.
//

import Foundation

extension [Logbook.Section.Entry] {
    static let backup: Self = [
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1657471200),
            tops: [.sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1657653780),
            tops: [.sample5, .sample4, .sample4, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1658173560),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1658776860),
            tops: [.sample7, .sample7, .sample7, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1659033720),
            tops: [.sample7, .sample7, .sample7, .sample5, .sample5, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1659468720),
            tops: [.sample7, .sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1659889680),
            tops: [.sample7, .sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1660154880),
            tops: [.sample7, .sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1660760520),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1662059220),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1664474880),
            tops: [.sample7, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1664996880),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1665231840),
            tops: [.sample7, .sample7, .sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1665683580),
            tops: [.sample7, .sample7, .sample4, .sample4, .sample4, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1665939660),
            tops: [.sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1666444620),
            tops: [.sample7, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1666807740),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample2, .sample2, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1, .sample1, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1667130540),
            tops: [.sample7, .sample7, .sample7, .sample5, .sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1667334540),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1667740620),
            tops: [.sample7, .sample7, .sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1668360300),
            tops: [.sample7, .sample7, .sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1668619260),
            tops: [.sample5, .sample5, .sample5, .sample5, .sample4, .sample4, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1669553100),
            tops: [.sample5, .sample5, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1670163180),
            tops: [.sample7, .sample5, .sample4, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1671029460),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1671628260),
            tops: [.sample5, .sample5, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1672860840),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1673201220),
            tops: [.sample6, .sample5, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1673376600),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1673800920),
            tops: [.sample6, .sample4, .sample4, .sample3, .sample3, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1673991000),
            tops: [.sample7, .sample4, .sample3, .sample3, .sample2, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1674326820),
            tops: [.sample7, .sample5, .sample3, .sample2, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1674590940),
            tops: [.sample5, .sample4, .sample4, .sample3, .sample3, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1674844920),
            tops: [.sample5, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1675194060),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1675606800),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1676225220),
            tops: [.sample7, .sample6, .sample5, .sample4, .sample3, .sample2, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1676485620),
            tops: [.sample7, .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .sample4, .sample4, .sample3, .sample3, .sample2, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        )   
    ]
}
