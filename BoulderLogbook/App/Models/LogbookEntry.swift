//
//  LogbookEntry.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct LogbookEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    var tops: [BoulderGrade]
}

extension LogbookEntry {
    var logText: String {
        let dictionary = tops.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        let keys = Array(dictionary.keys).sorted(by: { $0.rawValue > $1.rawValue })
        var string = ""
        keys.forEach { key in
            string.append("\(key.gradeDescription): \(dictionary[key] ?? 0)")
            if keys[keys.count - 1] != key {
                string.append(", ")
            }
        }
        return string
    }
    
    func numberOfGrades(for grade: BoulderGrade) -> String {
        let dictionary = tops.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        return "\(grade.gradeDescription): \(dictionary[grade] ?? 0)"
    }
}

let exampleLogbook: [LogbookEntry] = [
    LogbookEntry(
        id: UUID(),
        date: .now,
        tops: [.white, .white, .black, .black, .black]
    ),
    LogbookEntry(
        id: UUID(),
        date: Date(timeIntervalSinceNow: -86400),
        tops: [.white, .black, .black, .black, .black]
    ),
    LogbookEntry(
        id: UUID(),
        date: Date(timeIntervalSinceNow: -86400 * 2),
        tops: [.black, .black, .black, .orange, .orange]
    )
]
