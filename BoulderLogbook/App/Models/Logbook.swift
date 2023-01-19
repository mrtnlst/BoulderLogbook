//
//  LogbookData.swift
//  BoulderLogbook
//
//  Created by martin on 13.08.22.
//

import Foundation

public struct Logbook: Equatable {
    var sections: [Section]
}

extension Logbook {
    static let sampleLogbook = Logbook(sections: Logbook.Section.sampleSections)
}
