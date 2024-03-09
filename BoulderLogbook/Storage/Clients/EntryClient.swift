//
//  EntryClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 04.02.23.
//

import Foundation
import Dependencies

struct EntryClient {
    var fetchEntries: () async -> [Logbook.Section.Entry]
    var fetchSections: () async -> [Logbook.Section]
    var saveEntry: (Logbook.Section.Entry) async -> Void
    var updateEntry: (Logbook.Section.Entry) async -> Void
    var saveBackupEntries: () -> Void
    var deleteEntry: (UUID) async -> Void
    var deleteEntries: (UUID) async -> Void
    var migrateEntries: () async -> Void
}

extension DependencyValues {
    var entryClient: EntryClient {
        get { self[EntryClient.self] }
        set { self[EntryClient.self] = newValue }
    }
}

extension EntryClient: DependencyKey {
    static let liveValue = BoulderLogbookApp.dependencies.logbookEntryService.toClient()
     static let previewValue: Self = {
         return Self(
            fetchEntries: { .samples },
            fetchSections: {
                let dictionary = Dictionary(grouping: [Logbook.Section.Entry].samples, by: \.date.yearMonthDate)
                let sections = dictionary.keys.compactMap { date -> Logbook.Section? in
                    guard let date = date, let entries = dictionary[date] else {
                        return nil
                    }
                    return Logbook.Section(date: date, entries: entries)
                }
                return sections
            },
            saveEntry: { _ in },
            updateEntry: { _ in },
            saveBackupEntries: { },
            deleteEntry: { _ in },
            deleteEntries: { _ in },
            migrateEntries: { }
         )
     }()
}
