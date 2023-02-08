//
//  Filter.swift
//  BoulderLogbook
//
//  Created by Martin List on 08.02.23.
//

import Foundation

struct Filter: Equatable, Identifiable, Codable {
    let id: UUID
    var isOn: Bool
    
    init(id: UUID, isOn: Bool) {
        self.id = id
        self.isOn = isOn
    }
}

extension Filter {
    static var samples: [Filter] {
        GradeSystem.mandala.grades.map { Filter(id: $0.id, isOn: true) }
    }
}
