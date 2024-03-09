//
//  LogbookEntryService.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.03.24.
//

import CoreData

fileprivate extension String {
    static let entries = "logbook-entries"
    static let backupEntries = "backup-entries"
}

final class LogbookEntryService {
    private let storage: CoreDataStorage
    private let backgroundContext: NSManagedObjectContext
    private let defaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        storage: CoreDataStorage,
        backgroundContext: NSManagedObjectContext,
        defaults: UserDefaults = .standard,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.defaults = defaults
        self.decoder = decoder
        self.encoder = encoder
        self.backgroundContext = backgroundContext
    }

    func fetchAvailableSections() async -> [Logbook.Section] {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let sections: [LogbookSectionMO] = storage.fetch(on: backgroundContext)
                continuation.resume(returning: sections.map { $0.toLogbookSection() })
            }
        }
    }

    func fetchAvailableEntries() async -> [Logbook.Section.Entry] {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let sections: [LogbookEntryMO] = storage.fetch(on: backgroundContext)
                continuation.resume(returning: sections.map { $0.toLogbookEntry() })
            }
        }
    }

    func saveEntry(_ entry: Logbook.Section.Entry) async {
        // The entry needs to be assignable to a section.
        guard let date = entry.date.yearMonthDate else {
            return
        }
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let predicate = NSPredicate(format: "%K == %@", #keyPath(LogbookSectionMO.date), date as NSDate)
                if let existingSection: LogbookSectionMO = storage.fetch(predicate: predicate, on: backgroundContext).first {
                    let entryMO = insertEntry(entry, into: backgroundContext)
                    existingSection.entries.insert(entryMO)
                } else {
                    insertSection(for: date, and: [entry], into: backgroundContext)
                }
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }

    func updateEntry(_ entry: Logbook.Section.Entry) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let predicate = NSPredicate(format: "%K == %@", #keyPath(LogbookEntryMO.id), entry.id as NSUUID)
                guard let entryMO: LogbookEntryMO = storage.fetch(predicate: predicate, on: backgroundContext).first else {
                    continuation.resume()
                    return
                }
                entryMO.date = entry.date
                entryMO.gradeSystem = entry.gradeSystem
                entryMO.notes = entry.notes
                entryMO.tops.forEach {
                    storage.delete(object: $0, from: backgroundContext)
                }
                entry.tops.forEach { top in
                    let topMO: TopMO = storage.insert(into: backgroundContext)
                    topMO.id = top.id
                    topMO.grade = top.grade
                    topMO.wasAttempt = top.isAttempt
                    topMO.wasFlash = top.wasFlash
                    topMO.wasOnsight = top.wasOnsight
                    topMO.entry = entryMO
                }
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }

    func deleteEntry(for id: Logbook.Section.Entry.ID) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let predicate = NSPredicate(format: "%K == %@", #keyPath(LogbookEntryMO.id), id as NSUUID)
                guard let entryMO: LogbookEntryMO = storage.fetch(predicate: predicate, on: backgroundContext).first else {
                    continuation.resume()
                    return
                }
                let section = entryMO.section
                storage.delete(object: entryMO, from: backgroundContext)
                storage.save(on: backgroundContext)
                // If the section has no entries anymore, it can be deleted as well.
                if section.entries.isEmpty {
                    storage.delete(object: section, from: backgroundContext)
                }
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }

    func deleteEntries(of gradeSystem: GradeSystem.ID) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let predicate = NSPredicate(format: "%K == %@", #keyPath(LogbookEntryMO.gradeSystem), gradeSystem as NSUUID)
                let entries: [LogbookEntryMO] = storage.fetch(predicate: predicate, on: backgroundContext)
                entries.forEach { storage.delete(object: $0, from: backgroundContext) }

                let sections: [LogbookSectionMO] = storage.fetch(on: backgroundContext)
                sections.forEach {
                    if $0.entries.isEmpty {
                        storage.delete(object: $0, from: backgroundContext)
                    }
                }
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }

    func migrateLogbookEntries() async {
        guard let encodedData = defaults.object(forKey: .entries) as? Data,
              let decodedData = try? decoder.decode([Logbook.Section.Entry].self, from: encodedData)
        else {
            return
        }
        let dictionary = Dictionary(grouping: decodedData, by: \.date.yearMonthDate)
        let sections = dictionary.keys.compactMap { key -> Logbook.Section? in
            guard let date = key, let entries = dictionary[key] else {
                return nil
            }
            return Logbook.Section(date: date, entries: entries)
        }

        let availableSections = await fetchAvailableSections()
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                for section in sections {
                    guard !availableSections.contains(where: { $0.date == section.date }) else {
                        continue
                    }
                    insertSection(for: section.date, and: section.entries, into: backgroundContext)
                }
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }

    func saveBackupEntries() {
        guard !defaults.bool(forKey: .backupEntries) else {
            return
        }
        let data = try? JSONEncoder().encode([Logbook.Section.Entry].samples)
        defaults.set(data, forKey: .entries)
        defaults.set(true, forKey: .backupEntries)
    }
}

private extension LogbookEntryService {
    func insertSection(
        for date: Date,
        and entries: [Logbook.Section.Entry],
        into context: NSManagedObjectContext
    ) {
        let sectionMO: LogbookSectionMO = storage.insert(into: context)
        sectionMO.date = date
        for entry in entries {
            let entryMO = insertEntry(entry, into: context)
            entryMO.section = sectionMO
        }
    }

    func insertEntry(
        _ entry: Logbook.Section.Entry,
        into context: NSManagedObjectContext
    ) -> LogbookEntryMO {
        let entryMO: LogbookEntryMO = storage.insert(into: context)
        entryMO.id = entry.id
        entryMO.date = entry.date
        entryMO.notes = entry.notes
        entryMO.gradeSystem = entry.gradeSystem
        entry.tops.forEach { top in
            let topMO: TopMO = storage.insert(into: context)
            topMO.id = top.id
            topMO.grade = top.grade
            topMO.wasAttempt = top.isAttempt
            topMO.wasFlash = top.wasFlash
            topMO.wasOnsight = top.wasOnsight
            topMO.entry = entryMO
        }
        return entryMO
    }
}
