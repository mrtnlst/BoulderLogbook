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
            entries: [
                .samples[0],
                .samples[1]
            ]
        ),
        Logbook.Section(
            date: Date(timeIntervalSince1970: 1659304801),
            entries: [
                .samples[2],
                .samples[3]
            ]
        )
    ]
}

extension Logbook.Section.Entry {
    static var samples: [Logbook.Section.Entry] = [
        .init(
            date: Date(timeIntervalSince1970: 1659650401),
            tops: [.sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            date: Date(timeIntervalSince1970: 1659823201),
            tops: [.sample6, .sample5, .sample4, .sample2, .sample2, .sample3, .sample2, .sample1, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            date: Date(timeIntervalSince1970: 1656799201),
            tops: [.sample7, .sample7, .sample6, .sample4, .sample4, .sample4, .sample4, .sample3, .sample2, .sample2, .sample1],
            gradeSystem: GradeSystem.mandala.id
        ),
        .init(
            date: Date(timeIntervalSince1970: 1656972001),
            tops: [.sample6, .sample4, .sample4, .sample4, .sample4, .sample4, .sample4, .sample3, .sample3, .sample3],
            gradeSystem: GradeSystem.mandala.id
        )
    ]
}
