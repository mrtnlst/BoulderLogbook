//
//  LogbookData.swift
//  BoulderLogbook
//
//  Created by martin on 13.08.22.
//

import Foundation

public struct LogbookData: Equatable {
    var sections: [Section]
}

extension LogbookData {
    static let sampleLogbook = LogbookData(sections: LogbookData.Section.sampleSections)
}
