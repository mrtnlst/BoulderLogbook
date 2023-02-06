//
//  StorageService.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import Dependencies

private enum StorageServiceKey: DependencyKey {
    static var liveValue: StorageServiceType = StorageService()
}

extension DependencyValues {
    var storageService: StorageServiceType {
        get { self[StorageServiceKey.self] }
        set { self[StorageServiceKey.self] = newValue }
    }
}

fileprivate extension String {
    static let logbookKey = "Logbook"
    static let logbookVersionKey = "Logbook_v2"
}

protocol StorageServiceType {
    func fetch() -> Logbook
    func save(_ logbookEntry: Logbook.Section.Entry)
    func delete(_ logbookEntry: Logbook.Section.Entry)
    
    func fetchFilters() -> [LegacyBoulderGrade]
    func fetchFilter(_ filterKey: String) -> Bool
    func saveFilter(_ filterKey: String, with value: Bool)
}

final class StorageService {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

// MARK: - LogbookData Entries
extension StorageService: StorageServiceType {
    func fetch() -> Logbook {
        let data = fetchLogbookData()
        if !userDefaults.bool(forKey: .logbookVersionKey),
           let encodedLogbook = try? JSONEncoder().encode(data) {
            // One time migration to add `id` to `LoogbookEntry`.
            userDefaults.set(encodedLogbook, forKey: .logbookKey)
            userDefaults.set(true, forKey: .logbookVersionKey)
        }
        return data.toLogbook()
    }
    
    func save(_ logbookEntry: Logbook.Section.Entry) {
        var data = fetchLogbookData()
        let newEntryData = EntryData(
            id: logbookEntry.id.uuidString,
            date: logbookEntry.date,
            tops: []
//            tops: logbookEntry.tops
        )
        // Update existing entry or add new entry.
        if let editedEntryData = data.logbookEntries.firstIndex(where: { $0.id == logbookEntry.id.uuidString }) {
            data.logbookEntries[editedEntryData] = newEntryData
        } else {
            data.logbookEntries.append(newEntryData)
        }
        
        // Encode LogbookData and save back to UserDefaults.
        if let encodedLogbookData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedLogbookData, forKey: .logbookKey)
        }
    }
    
    func delete(_ logbookEntry: Logbook.Section.Entry) {
        var data = fetchLogbookData()
        data.logbookEntries.removeAll(where: { $0.id == logbookEntry.id.uuidString })
        
        if let encodedData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedData, forKey: .logbookKey)
        }
    }
}

private extension StorageService {
    func fetchLogbookData() -> LogbookData {
        if let encodedData = userDefaults.object(forKey: .logbookKey) as? Data,
           let decodedData = try? JSONDecoder().decode(LogbookData.self, from: encodedData) {
            return decodedData
        }
        let newData = LogbookData(logbookEntries: [])
        if let encodedData = try? JSONEncoder().encode(newData) {
            UserDefaults.standard.set(encodedData, forKey: .logbookKey)
        }
        return newData
    }
}

// MARK: - Filters
extension StorageService {
    func fetchFilter(_ filterKey: String) -> Bool {
        return userDefaults.object(forKey: filterKey) as? Bool ?? false
    }
    
    func fetchFilters() -> [LegacyBoulderGrade] {
        // We distinguish between active, inactive and not saved filters.
        let filters = LegacyBoulderGrade.allCases.reduce(into: [LegacyBoulderGrade: Bool]()) { partialResult, value in
            if let state = userDefaults.object(forKey: value.gradeDescription) as? Bool {
                partialResult[value] = state
            }
        }
        // If no filters have been saved we assume a fresh install and show all.
        if filters.isEmpty {
            LegacyBoulderGrade.allCases.forEach {
                saveFilter($0.gradeDescription, with: true)
            }
            return LegacyBoulderGrade.allCases
        }
        // We only return the active filters.
        let activeFilters = filters.compactMap { $0.value ? $0.key : nil }
        return activeFilters
    }

    func saveFilter(_ filterKey: String, with value: Bool) {
        userDefaults.set(value, forKey: filterKey)
    }
}
