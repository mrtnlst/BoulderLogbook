//
//  LogbookEntryServiceType.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.04.26.
//

import Foundation

protocol LogbookEntryServiceType: Sendable {
    func fetchAvailableSections() async -> [Logbook.Section]
    func fetchAvailableEntries() async -> [Logbook.Section.Entry]
    func saveEntry(_ entry: Logbook.Section.Entry) async
    func updateEntry(_ entry: Logbook.Section.Entry) async
    func deleteEntry(for id: Logbook.Section.Entry.ID) async
    func deleteEntries(of gradeSystem: GradeSystem.ID) async
    func migrateLogbookEntries() async
    func saveBackupEntries() async
}

extension LogbookEntryServiceType {
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
            await self.saveBackupEntries()
        } deleteEntry: {
            await self.deleteEntry(for: $0)
        } deleteEntries: {
            await self.deleteEntries(of: $0)
        } migrateEntries: {
            await self.migrateLogbookEntries()
        }
    }
}
