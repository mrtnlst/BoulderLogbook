//
//  EntryAction.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import Foundation

public enum EntryAction: Equatable {
    case delete(Logbook.Entry)
    case edit(Logbook.Entry)
}
