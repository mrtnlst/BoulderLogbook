//
//  FormState.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct FormState: Equatable {
    var entry: LogbookData.Entry
    let isNewEntry: Bool
    
    init(entry: LogbookData.Entry = LogbookData.Entry(id: UUID().uuidString, date: .now, tops: []), isNewEntry: Bool = true) {
        self.entry = entry
        self.isNewEntry = isNewEntry
    }
}
