//
//  EntryState.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import Foundation

public struct EntryState: Equatable {
    var entry: LogbookData.Entry
}

extension EntryState: Identifiable {
    public var id: String {
        entry.id
    }
}
