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
    func fetch() -> Effect<[LogbookEntry], Never>
    func save(logbookEntry: LogbookEntry) -> Effect<Never, Never>
}

final class StorageService: StorageServiceType {
    func fetch() -> Effect<[LogbookEntry], Never> {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        return Future { promise in
            var logbookEntries: [LogbookEntry] = []
            if let logbookData = defaults.object(forKey: "Logbook") as? Data {
                if let logbook = try? decoder.decode(Logbook.self, from: logbookData) {
                    logbookEntries = logbook.logbookEntries
                }
            }
            promise(.success(logbookEntries))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func save(logbookEntry: LogbookEntry) -> ComposableArchitecture.Effect<Never, Never> {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        if let logbookData = defaults.object(forKey: "Logbook") as? Data {
            if var logbook = try? decoder.decode(Logbook.self, from: logbookData) {
                logbook.logbookEntries.append(logbookEntry)
                if let encoded = try? encoder.encode(logbook) {
                    defaults.set(encoded, forKey: "Logbook")
                }
            }
        } else {
            let logbook = Logbook(logbookEntries: [logbookEntry])
            if let encoded = try? encoder.encode(logbook) {
                defaults.set(encoded, forKey: "Logbook")
            }
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
}
