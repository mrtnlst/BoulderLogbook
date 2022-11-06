//
//  StorageService.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import Combine
import ComposableArchitecture

protocol StorageServiceType {
    func fetch() -> Effect<LogbookData, Never>
    func save(logbookEntry: LogbookData.Entry) -> Effect<Never, Never>
    func delete(logbookEntry: LogbookData.Entry) -> Effect<Never, Never>
    func fetch(filterKey: String) -> Effect<Bool, Never>
    func fetchFilters() -> Effect<[BoulderGrade], Never>
    func save(value: Bool, for filterKey: String) -> Effect<Never, Never>
}

final class StorageService: StorageServiceType {}

// MARK: - Logbook Entries
extension StorageService {
    func fetch() -> Effect<LogbookData, Never> {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        return Future { promise in
            if let logbookData = defaults.object(forKey: "Logbook") as? Data {
                if let decodedLogbook = try? decoder.decode(Logbook.self, from: logbookData) {
                    promise(.success(decodedLogbook.toLogbookData()))
                }
            }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func save(logbookEntry: LogbookData.Entry) -> Effect<Never, Never> {
        // Obtain Logbook from UserDefaults or create new if unavailable.
        var logbook: Logbook?
        if let logbookData = UserDefaults.standard.object(forKey: "Logbook") as? Data,
           let decodedLogbook = try? JSONDecoder().decode(Logbook.self, from: logbookData) {
            logbook = decodedLogbook
        } else {
            logbook = Logbook(logbookEntries: [])
        }
        
        let newLogbookEntry = LogbookEntry(
            date: logbookEntry.date,
            tops: logbookEntry.tops
        )
        if let editedEntry = logbook?.logbookEntries.firstIndex(where: { $0.id == logbookEntry.id }) {
            logbook?.logbookEntries[editedEntry] = newLogbookEntry
        } else {
            logbook?.logbookEntries.append(newLogbookEntry)
        }
        
        // Encode Logbook and save back to UserDefaults.
        if let encodedLogbook = try? JSONEncoder().encode(logbook) {
            UserDefaults.standard.set(encodedLogbook, forKey: "Logbook")
        }
        return Empty()
            .eraseToAnyPublisher()
            .eraseToEffect()
    }
    
    func delete(logbookEntry: LogbookData.Entry) -> Effect<Never, Never> {
        guard let logbookData = UserDefaults.standard.object(forKey: "Logbook") as? Data,
              var logbook = try? JSONDecoder().decode(Logbook.self, from: logbookData) else {
            return Empty().eraseToAnyPublisher().eraseToEffect()
        }
        logbook.logbookEntries.removeAll(where: { $0.id == logbookEntry.id })
        
        if let encodedLogbook = try? JSONEncoder().encode(logbook) {
            UserDefaults.standard.set(encodedLogbook, forKey: "Logbook")
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
