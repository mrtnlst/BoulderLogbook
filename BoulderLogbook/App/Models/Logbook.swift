//
//  LogbookData.swift
//  BoulderLogbook
//
//  Created by martin on 13.08.22.
//

import Foundation

struct Logbook: Equatable {
    struct Section: Equatable {
        struct Entry: Identifiable, Equatable, Hashable, Codable {
            public let id: UUID
            var date: Date
            var notes: String?
            var tops: [Top]
            var gradeSystem: UUID
            
            enum CodingKeys: String, CodingKey {
                case id, date, notes, tops, gradeSystem
            }
            
            init(
                id: UUID = UUID(),
                date: Date,
                notes: String? = nil,
                tops: [Top] = [],
                gradeSystem: UUID
            ) {
                self.id = id
                self.date = date
                self.notes = notes
                self.tops = tops
                self.gradeSystem = gradeSystem
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.id = try container.decode(UUID.self, forKey: .id)
                self.date = try container.decode(Date.self, forKey: .date)
                self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
                self.tops = try container.decode([Top].self, forKey: .tops)
                self.gradeSystem = try container.decode(UUID.self, forKey: .gradeSystem)
            }
        }
        var date: Date
        var entries: [Entry]
    }
    var sections: [Section]
}
