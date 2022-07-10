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
    func delete(logbookEntries: IndexSet, in section: Date) -> Effect<Never, Never>
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
        
        guard let sectionDate = Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month, .day], from: logbookEntry.date)
        ) else {
            fatalError("No Date could be saved")
        }
        
        // Add new entry to existing section or create new section by date.
        if let sectionForDate = logbook?.logbookSections.firstIndex(where: { $0.date == sectionDate }) {
            logbook?.logbookSections[sectionForDate].logbookEntries.append(logbookEntry)
        } else {
            logbook?.logbookSections.append(
                LogbookSection(
                    date: sectionDate,
                    logbookEntries: [logbookEntry]
                )
            )
        }
        
        // Encode Logbook and save back to UserDefaults.
        if let encodedLogbook = try? JSONEncoder().encode(logbook) {
            UserDefaults.standard.set(encodedLogbook, forKey: "Logbook")
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func delete(logbookEntries: IndexSet, in section: Date) -> Effect<Never, Never> {
        guard let logbookData = UserDefaults.standard.object(forKey: "Logbook") as? Data,
              var logbook = try? JSONDecoder().decode(Logbook.self, from: logbookData) else {
            return Empty().eraseToAnyPublisher().eraseToEffect()
        }
        
        if let sectionIndex = logbook.logbookSections.firstIndex(where: { $0.date == section }) {
            logbook.logbookSections[sectionIndex].logbookEntries.remove(atOffsets: logbookEntries)
            if logbook.logbookSections[sectionIndex].logbookEntries.isEmpty {
                logbook.logbookSections.remove(at: sectionIndex)
            }
        }
        
        if let encodedLogbook = try? JSONEncoder().encode(logbook) {
            UserDefaults.standard.set(encodedLogbook, forKey: "Logbook")
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
}
