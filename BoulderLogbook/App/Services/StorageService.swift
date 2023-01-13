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
}

final class StorageService: StorageServiceType {
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
            id: logbookEntry.id,
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
