//
//  LogbookEntryClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 04.02.23.
//

import Foundation
import Dependencies

struct LogbookEntryClient {
    var fetchEntries: () async -> [Logbook.Section.Entry]
    var fetchSections: () async -> [Logbook.Section]
    var saveEntry: (Logbook.Section.Entry) async -> Void
    var updateEntry: (Logbook.Section.Entry) async -> Void
    var saveBackupEntries: () -> Void
    var deleteEntry: (UUID) async -> Void
    var deleteEntries: (UUID) async -> Void
    var migrateEntries: () async -> Void
}

extension LogbookEntryService {
    func toClient() -> LogbookEntryClient {
        LogbookEntryClient {
            await self.fetchAvailableEntries()
        } fetchSections: {
            await self.fetchAvailableSections()
        } saveEntry: {
            await self.saveEntry($0)
        } updateEntry: {
            await self.updateEntry($0)
        } saveBackupEntries: {
            self.saveBackupEntries()
        } deleteEntry: {
            await self.deleteEntry(for: $0)
        } deleteEntries: {
            await self.deleteEntries(of: $0)
        } migrateEntries: {
            await self.migrateLogbookEntries()
        }
    }
}

extension LogbookEntryClient: DependencyKey {
    static let liveValue = BoulderLogbookApp.dependencies.logbookEntryService.toClient()
     static let previewValue: Self = {
         return LogbookEntryClient(
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
