//
//  LogbookEntryClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 04.02.23.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct LogbookEntryClient {
    var fetchEntries: @Sendable () async -> [Logbook.Section.Entry] = { [] }
    var fetchSections: @Sendable () async -> [Logbook.Section] = { [] }
    var saveEntry: @Sendable (Logbook.Section.Entry) async -> Void
    var updateEntry: @Sendable (Logbook.Section.Entry) async -> Void
    var saveBackupEntries: @Sendable () async -> Void
    var deleteEntry: @Sendable (UUID) async -> Void
    var deleteEntries: @Sendable (UUID) async -> Void
    var migrateEntries: @Sendable () async -> Void
}

extension LogbookEntryClient: DependencyKey {
    static let liveValue = Self()
    static let previewValue: Self = {
        LogbookEntryClient(
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

extension DependencyValues {
    var logbookEntryClient: LogbookEntryClient {
        get { self[LogbookEntryClient.self] }
        set { self[LogbookEntryClient.self] = newValue }
    }
}
