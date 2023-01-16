//
//  LogbookEntry.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct LogbookEntry: Codable, Equatable {
    var id: String
    var date: Date
    var tops: [BoulderGrade]
   
    init(id: String, date: Date, tops: [BoulderGrade]) {
        self.id = id
        self.date = date
        self.tops = tops
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decode(String.self, forKey: .id)
        } catch {
            self.id = UUID().uuidString
        }
        self.date = try container.decode(Date.self, forKey: .date)
        self.tops = try container.decode([BoulderGrade].self, forKey: .tops)
    }
}
