//
//  StorageService.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import Combine
import ComposableArchitecture
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
    func save(_ logbookEntry: Logbook.Entry)
    func delete(logbookEntry: Logbook.Entry) -> EffectPublisher<Never, Never>
    func fetch(filterKey: String) -> EffectPublisher<Bool, Never>
    func fetchFilters() -> EffectPublisher<[BoulderGrade], Never>
    func save(value: Bool, for filterKey: String) -> EffectPublisher<Never, Never>
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
        
    func save(_ logbookEntry: Logbook.Entry) {
        var data = fetchLogbookData()
        let newEntryData = EntryData(
            id: logbookEntry.id,
            date: logbookEntry.date,
            tops: logbookEntry.tops
        )
        // Update existing entry or add new entry.
        if let editedEntryData = data.logbookEntries.firstIndex(where: { $0.id == logbookEntry.id }) {
            data.logbookEntries[editedEntryData] = newEntryData
        } else {
            data.logbookEntries.append(newEntryData)
        }
        
        // Encode LogbookData and save back to UserDefaults.
        if let encodedLogbookData = try? JSONEncoder().encode(data) {
            userDefaults.set(encodedLogbookData, forKey: .logbookKey)
        }
    }
    
    func delete(logbookEntry: Logbook.Entry) -> EffectPublisher<Never, Never> {
        guard let encodedLogbookData = UserDefaults.standard.object(forKey: .logbookKey) as? Data,
              var logbookData = try? JSONDecoder().decode(LogbookData.self, from: encodedLogbookData) else {
            return Empty().eraseToAnyPublisher().eraseToEffect()
        }
        logbookData.logbookEntries.removeAll(where: { $0.id == logbookEntry.id })
        
        if let encodedLogbook = try? JSONEncoder().encode(logbookData) {
            UserDefaults.standard.set(encodedLogbook, forKey: .logbookKey)
        }
        return Empty()
            .eraseToAnyPublisher()
            .eraseToEffect()
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
    func fetch(filterKey: String) -> EffectPublisher<Bool, Never> {
        let defaults = UserDefaults.standard
        return Future { promise in
            if let object = defaults.object(forKey: filterKey) as? Bool {
                return promise(.success(object))
            }
            promise(.success(true))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func fetchFilters() -> EffectPublisher<[BoulderGrade], Never> {
        let defaults = UserDefaults.standard
        return Future { promise in
            // We distinguish between active, inactive and not saved filters.
            let filters = BoulderGrade.allCases.reduce(into: [BoulderGrade: Bool]()) { partialResult, value in
                let state = defaults.bool(forKey: value.gradeDescription)
                partialResult[value] = state
            }
            // If no filters have been saved we assume a fresh install and show all.
            if filters.isEmpty {
                BoulderGrade.allCases.forEach {
                    _ = self.save(value: true, for: $0.gradeDescription)
                }
                return promise(.success(BoulderGrade.allCases))
            }
            // We only return the active filters.
            let activeFilters = filters.compactMap { $0.value ? $0.key : nil }
            return promise(.success(activeFilters))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func save(value: Bool, for filterKey: String) -> EffectPublisher<Never, Never> {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: filterKey)
        return Empty()
            .eraseToAnyPublisher()
            .eraseToEffect()
    }
}
