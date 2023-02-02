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
            tops: [.black, .black, .black, .black, .black, .orange, .orange, .blue, .blue]
        ),
        .init(
            date: Date(timeIntervalSince1970: 1659823201),
            tops: [.yellow, .white, .black, .red, .red, .orange, .red, .blue]
        ),
        .init(
            date: Date(timeIntervalSince1970: 1656799201),
            tops: [.purple, .purple, .white, .black, .black, .black, .black, .orange, .red, .red, .blue]
        ),
        .init(
            date: Date(timeIntervalSince1970: 1656972001),
            tops: [.white, .black, .black, .black, .black, .black, .black, .orange, .orange, .orange]
        )
    ]
}
