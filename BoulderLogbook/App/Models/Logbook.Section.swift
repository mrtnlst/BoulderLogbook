//
//  Logbook.Section.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.08.22.
//

import Foundation

extension Logbook {
    struct Section: Equatable {
        var date: Date
        var entries: [Entry]
    }
}

extension Logbook.Section {
    static var sampleSections: [Logbook.Section] = [
        Logbook.Section(
            date: Date(timeIntervalSince1970: 1656626401),
            entries: [
                Logbook.Entry.sampleEntries[0],
                Logbook.Entry.sampleEntries[1]
            ]
        ),
        Logbook.Section(
            date: Date(timeIntervalSince1970: 1659304801),
            entries: [
                Logbook.Entry.sampleEntries[2],
                Logbook.Entry.sampleEntries[3]
            ]
        )
    ]
}
