//
//  FormState.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

struct FormState: Equatable {
    var logbookEntry: LogbookData.Entry = LogbookData.Entry(date: .now, tops: [])
}
