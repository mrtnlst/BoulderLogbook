//
//  FormState.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct FormState: Equatable {
    var entry: Logbook.Entry
    let isNewEntry: Bool
    
    init(entry: Logbook.Entry = Logbook.Entry(date: .now, tops: []), isNewEntry: Bool = true) {
        self.entry = entry
        self.isNewEntry = isNewEntry
    }
}
