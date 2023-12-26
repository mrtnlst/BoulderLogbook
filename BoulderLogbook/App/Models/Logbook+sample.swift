//
//  Logbook+sample.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.02.23.
//

import Foundation

extension Logbook {
    static let sample = Logbook(sections: Logbook.Section.samples)
}

extension Logbook.Section {
    static var samples: [Logbook.Section] = [
        Logbook.Section(
            date: Date(timeIntervalSince1970: 1656626401),
            entries: Array([Logbook.Section.Entry].samples[0...4])
        ),
        Logbook.Section(
            date: Date(timeIntervalSince1970: 1659304801),
            entries: Array([Logbook.Section.Entry].samples[5...8])
        )
    ]
}

extension [Logbook.Section.Entry] {
    static let samples: Self = [
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
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1676917822),
            tops: [.init(id: UUID(), grade: GradeSystem.Grade.mandalaPurple.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1677613117),
            tops: [.sample5, .sample5, .sample4, .sample3, .sample3, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1678215337),
            tops: [.sample4, .sample3, .sample3, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1679002777),
            tops: [.sample5, .sample4, .sample3, .sample2],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1679154217),
            tops: [.sample6, .sample5, .sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1679428117),
            tops: [.sample5, .sample5, .sample4, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1679747377),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1680040597),
            tops: [.sample7, .sample5, .sample5, .sample5, .sample5, .sample4, .sample4, .sample3, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1681114837),
            tops: [.sample3, .sample3, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1682410837),
            tops: [.sample7, .sample7, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1683710857),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1684067077),
            tops: [.sample7, .sample7, .sample6, .sample5, .sample5, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1684958197),
            tops: [.sample4, .sample4, .sample4, .sample3, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1685877877),
            tops: [.sample7, .sample7, .sample5, .sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1686162697),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1686397837),
            tops: [.sample4, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1686769537),
            tops: [.sample7, .sample7, .sample4, .sample4, .sample4, .sample4, .sample4, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1687286737),
            tops: [.sample5, .sample5, .sample4, .sample4, .sample3, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1687610917),
            tops: [.sample7, .sample7, .init(id: UUID(), grade: GradeSystem.Grade.mandalaYellow.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .sample5, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1688586462),
            tops: [.sample7, .init(id: UUID(), grade: GradeSystem.Grade.mandalaYellow.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaYellow.id, isAttempt: true, wasFlash: false, wasOnsight: false), .sample6, .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .sample5, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1688918202),
            tops: [.sample7, .init(id: UUID(), grade: GradeSystem.Grade.mandalaYellow.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1689358182),
            tops: [.sample7, .sample7, .init(id: UUID(), grade: GradeSystem.Grade.mandalaYellow.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaYellow.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaWhite.id, isAttempt: true, wasFlash: false, wasOnsight: false), .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1689707996),
            tops: [.sample5, .sample4, .sample3, .sample3, .sample3, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1689966176),
            tops: [.sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1689966176),
            tops: [.sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1690571336),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1690829756),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1691355416),
            tops: [.sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1691355416),
            tops: [.sample7, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1695059456),
            tops: [.sample7, .sample7, .sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1695754012),
            tops: [.sample5, .sample5, .sample4, .init(id: UUID(), grade: GradeSystem.Grade.mandalaBlack.id, isAttempt: false, wasFlash: true, wasOnsight: false), .init(id: UUID(), grade: GradeSystem.Grade.mandalaBlack.id, isAttempt: false, wasFlash: true, wasOnsight: false), .sample3, .sample3, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1696085420),
            tops: [.sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1696266860),
            tops: [.sample7, .sample5, .sample4, .sample3, .sample2, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1698870500),
            tops: [.sample7, .sample5, .sample5, .sample4, .sample4, .sample4, .sample4, .sample3, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1699300160),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample2, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1701119420),
            tops: [.sample7, .sample5, .sample4, .sample4, .sample4, .sample3, .sample2, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1701726080),
            tops: [.sample5, .sample4, .sample4, .sample4, .sample2, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1702750100),
            tops: [.sample7, .sample7, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1703347460),
            tops: [.sample5, .sample5, .sample5, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample2, .sample2, .sample2, .sample1, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            id: UUID(),
            date: Date(timeIntervalSince1970: 1703606300),
            tops: [.sample7, .sample7, .sample7, .sample5, .sample5, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3, .sample3, .sample3, .sample2],
            gradeSystem: GradeSystem.mandala.id
        )
    ]
}
