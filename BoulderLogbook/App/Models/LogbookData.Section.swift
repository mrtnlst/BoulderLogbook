//
//  LogbookData.Section.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.08.22.
//

import Foundation

extension LogbookData {
    struct Section: Equatable {
        var date: Date
        var entries: [Entry]
    }
}

extension LogbookData.Section {
    static var sampleSections: [LogbookData.Section] = [
        LogbookData.Section(
            date: Date(timeIntervalSince1970: 1656626401),
            entries: [
                LogbookData.Entry.sampleEntries[0],
                LogbookData.Entry.sampleEntries[1]
            ]
        ),
        LogbookData.Section(
            date: Date(timeIntervalSince1970: 1659304801),
            entries: [
                LogbookData.Entry.sampleEntries[2],
                LogbookData.Entry.sampleEntries[3]
            ]
        )
    ]
}
