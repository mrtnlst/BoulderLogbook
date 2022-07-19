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
    func delete(logbookEntry: LogbookEntry) -> Effect<Never, Never>
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
        
        if let editedEntry = logbook?.logbookEntries.firstIndex(where: { $0.id == logbookEntry.id }) {
            logbook?.logbookEntries[editedEntry] = logbookEntry
        } else if let entryToAppend = logbook?.logbookEntries.firstIndex(where: { $0.sectionDate == logbookEntry.sectionDate }) {
            logbook?.logbookEntries[entryToAppend].tops.append(contentsOf: logbookEntry.tops)
        } else {
            logbook?.logbookEntries.append(logbookEntry)
        }
        logbook?.logbookEntries.sort(by: { $0.sectionDate > $1.sectionDate } )
        
        // Encode Logbook and save back to UserDefaults.
        if let encodedLogbook = try? JSONEncoder().encode(logbook) {
            UserDefaults.standard.set(encodedLogbook, forKey: "Logbook")
        }
        return Empty()
            .eraseToAnyPublisher()
            .eraseToEffect()
    }
    
    func delete(logbookEntry: LogbookEntry) -> Effect<Never, Never> {
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
