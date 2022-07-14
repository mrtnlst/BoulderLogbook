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
    func fetch() -> Effect<Logbook, Never>
    func save(logbookEntry: LogbookEntry) -> Effect<Never, Never>
    func delete(logbookEntries: IndexSet) -> Effect<Never, Never>
}

final class StorageService: StorageServiceType {
    func fetch() -> Effect<Logbook, Never> {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        return Future { promise in
            if let logbookData = defaults.object(forKey: "Logbook") as? Data {
                if let decodedLogbook = try? decoder.decode(Logbook.self, from: logbookData) {
                    promise(.success(decodedLogbook))
                }
            }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func save(logbookEntry: LogbookEntry) -> ComposableArchitecture.Effect<Never, Never> {
        // Obtain Logbook from UserDefaults or create new if unavailable.
        var logbook: Logbook?
        if let logbookData = UserDefaults.standard.object(forKey: "Logbook") as? Data,
           let decodedLogbook = try? JSONDecoder().decode(Logbook.self, from: logbookData) {
            logbook = decodedLogbook
        } else {
            logbook = Logbook()
        }
        
        if let existingEntry = logbook?.logbookEntries.firstIndex(where: { $0.date == logbookEntry.date }) {
            logbook?.logbookEntries[existingEntry].tops.append(contentsOf: logbookEntry.tops)
        } else {
            logbook?.logbookEntries.append(logbookEntry)
        }
        
        // Encode Logbook and save back to UserDefaults.
        if let encodedLogbook = try? JSONEncoder().encode(logbook) {
            UserDefaults.standard.set(encodedLogbook, forKey: "Logbook")
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func delete(logbookEntries: IndexSet) -> Effect<Never, Never> {
        guard let logbookData = UserDefaults.standard.object(forKey: "Logbook") as? Data,
              var logbook = try? JSONDecoder().decode(Logbook.self, from: logbookData) else {
            return Empty().eraseToAnyPublisher().eraseToEffect()
        }
        logbook.logbookEntries.remove(atOffsets: logbookEntries)
        
        if let encodedLogbook = try? JSONEncoder().encode(logbook) {
            UserDefaults.standard.set(encodedLogbook, forKey: "Logbook")
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
}
