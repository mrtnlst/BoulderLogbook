//
//  Logbook.Entry.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.08.22.
//

import Foundation

extension Logbook {
    public struct Entry: Identifiable, Equatable, Hashable {
        public var id: String
        var date: Date
        var tops: [BoulderGrade]
        
        init(id: String = UUID().uuidString, date: Date, tops: [BoulderGrade]) {
            self.id = id
            self.date = date
            self.tops = tops
        }
    }
}

extension Logbook.Entry {
    var sectionDate: Date {
        date.yearMonthDate ?? date
    }
    
    var entryDate: Date {
        date.yearMonthDayDate ?? date
    }
    
    func numberOfGrades(for grade: BoulderGrade) -> Int {
        let dictionary = tops.reduce(into: [:]) { counts, number in
            counts[number, default: 0] += 1
        }
        return dictionary[grade] ?? 0
    }
}

extension Logbook.Entry {
    static var sampleEntries: [Logbook.Entry] = [
        Logbook.Entry(
            date: Date(timeIntervalSince1970: 1659650401),
            tops: [.black, .black, .black, .black, .black, .orange, .orange, .blue, .blue]
        ),
        Logbook.Entry(
            date: Date(timeIntervalSince1970: 1659823201),
            tops: [.yellow, .white, .black, .red, .red, .orange, .red, .blue]
        ),
        Logbook.Entry(
            date: Date(timeIntervalSince1970: 1656799201),
            tops: [.purple, .purple, .white, .black, .black, .black, .black, .orange, .red, .red, .blue]
        ),
        Logbook.Entry(
            date: Date(timeIntervalSince1970: 1656972001),
            tops: [.white, .black, .black, .black, .black, .black, .black, .orange, .orange, .orange]
        )
    ]
}
