//
//  StorageService.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import Combine
import ComposableArchitecture

fileprivate extension String {
    static let logbookKey = "Logbook"
    static let logbookVersionKey = "Logbook_v2"
}

protocol StorageServiceType {
    func fetch() -> Effect<Logbook, Never>
    func save(logbookEntry: Logbook.Entry) -> Effect<Never, Never>
    func delete(logbookEntry: Logbook.Entry) -> Effect<Never, Never>
    func fetch(filterKey: String) -> Effect<Bool, Never>
    func fetchFilters() -> Effect<[BoulderGrade], Never>
    func save(value: Bool, for filterKey: String) -> Effect<Never, Never>
}

final class StorageService: StorageServiceType {}

// MARK: - LogbookData Entries
extension StorageService {
    func fetch() -> Effect<Logbook, Never> {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        return Future { promise in
            if let logbookData = defaults.object(forKey: .logbookKey) as? Data,
               let decodedLogbookData = try? decoder.decode(LogbookData.self, from: logbookData) {
                if !defaults.bool(forKey: .logbookVersionKey),
                   let encodedLogbook = try? JSONEncoder().encode(decodedLogbookData) {
                    // One time migration to add `id` to `LoogbookEntry`.
                    defaults.set(encodedLogbook, forKey: .logbookKey)
                    defaults.set(true, forKey: .logbookVersionKey)
                }
                promise(.success(decodedLogbookData.toLogbook()))
            }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func save(logbookEntry: Logbook.Entry) -> Effect<Never, Never> {
        // Obtain LogbookData from UserDefaults or create new if unavailable.
        var logbookData: LogbookData?
        if let encodedLogbookData = UserDefaults.standard.object(forKey: .logbookKey) as? Data,
           let decodedLogbookData = try? JSONDecoder().decode(LogbookData.self, from: encodedLogbookData) {
            logbookData = decodedLogbookData
        } else {
            logbookData = LogbookData(logbookEntries: [])
        }
        let newEntryData = EntryData(
            id: logbookEntry.id,
            date: logbookEntry.date,
            tops: logbookEntry.tops
        )
        // Update existing entry or add new entry.
        if let editedEntryData = logbookData?.logbookEntries.firstIndex(where: { $0.id == logbookEntry.id }) {
            logbookData?.logbookEntries[editedEntryData] = newEntryData
        } else {
            logbookData?.logbookEntries.append(newEntryData)
        }
        
        // Encode LogbookData and save back to UserDefaults.
        if let encodedLogbookData = try? JSONEncoder().encode(logbookData) {
            UserDefaults.standard.set(encodedLogbookData, forKey: .logbookKey)
        }
        return Empty()
            .eraseToAnyPublisher()
            .eraseToEffect()
    }
    
    func delete(logbookEntry: Logbook.Entry) -> Effect<Never, Never> {
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

// MARK: - Filters
extension StorageService {
    func fetch(filterKey: String) -> Effect<Bool, Never> {
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
    
    func fetchFilters() -> Effect<[BoulderGrade], Never> {
        let defaults = UserDefaults.standard
        return Future { promise in
            let filters: [BoulderGrade] = BoulderGrade.allCases.filter {
                defaults.bool(forKey: $0.gradeDescription)
            }
            // If no filters have been adjusted, show all and save entries for that.
            if filters.isEmpty {
                BoulderGrade.allCases.forEach {
                    _ = self.save(value: true, for: $0.gradeDescription)
                }
                return promise(.success(BoulderGrade.allCases))
            }
            return promise(.success(filters))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func save(value: Bool, for filterKey: String) -> Effect<Never, Never> {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: filterKey)
        return Empty()
            .eraseToAnyPublisher()
            .eraseToEffect()
    }
}
