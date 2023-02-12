//
//  EntryClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 04.02.23.
//

import Foundation
import Dependencies

struct EntryClient {
    var fetchEntries: () -> [Logbook.Section.Entry]
    var saveEntry: (Logbook.Section.Entry) -> Void
    var deleteEntry: (UUID) -> Void
    var deleteEntries: (UUID) -> Void
}

extension DependencyValues {
    var entryClient: EntryClient {
        get { self[EntryClient.self] }
        set { self[EntryClient.self] = newValue }
    }
}

extension EntryClient: DependencyKey {
    static let liveValue: Self = {
        let defaults = UserDefaults.standard
        let entriesKey = "logbook-entries"
        return Self(
            fetchEntries: {
                if let oldEntryData = defaults.object(forKey: "Logbook") as? Data,
                   let decodedOldData = try? JSONDecoder().decode(LogbookData.self, from: oldEntryData) {
                    let newEntries = decodedOldData.toLogbookEntries()
                    let data = try? JSONEncoder().encode(newEntries)
                    defaults.set(data, forKey: entriesKey)
                }
                guard let encodedData = defaults.object(forKey: entriesKey) as? Data,
                      let decodedData = try? JSONDecoder().decode([Logbook.Section.Entry].self, from: encodedData)
                else {
                    return []
                }
                return decodedData
            },
            saveEntry: { newValue in
                var entries: [Logbook.Section.Entry]
                if let encodedData = defaults.object(forKey: entriesKey) as? Data,
                   let decodedData = try? JSONDecoder().decode([Logbook.Section.Entry].self, from: encodedData) {
                    entries = decodedData
                } else {
                    entries = []
                }
                
                if let existingValue = entries.firstIndex(where: { $0.id == newValue.id }) {
                    entries[existingValue] = newValue
                } else {
                    entries.append(newValue)
                }
                let data = try? JSONEncoder().encode(entries)
                defaults.set(data, forKey: entriesKey)
            },
            deleteEntry: { oldValue in
                guard let encodedData = defaults.object(forKey: entriesKey) as? Data,
                      var decodedData = try? JSONDecoder().decode([Logbook.Section.Entry].self, from: encodedData)
                else {
                    return
                }
                decodedData.removeAll(where: { $0.id == oldValue })
                
                let data = try? JSONEncoder().encode(decodedData)
                defaults.set(data, forKey: entriesKey)
            },
            deleteEntries: { gradeSystemId in
                guard let encodedData = defaults.object(forKey: entriesKey) as? Data,
                      var decodedData = try? JSONDecoder().decode([Logbook.Section.Entry].self, from: encodedData)
                else {
                    return
                }
                decodedData.removeAll(where: { $0.gradeSystem == gradeSystemId })
                
                let data = try? JSONEncoder().encode(decodedData)
                defaults.set(data, forKey: entriesKey)
            }
        )
    }()
    
    static let previewValue: Self = {
        return Self(
            fetchEntries: { return Logbook.Section.Entry.samples },
            saveEntry: { _ in },
            deleteEntry: { _ in },
            deleteEntries: { _ in }
        )
    }()
}
