//
//  Trend.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.09.26.
//

import Foundation

enum Trend {
    case up
    case down
    case stale
    case none
    
    init(currentCount: Int, previousCount: Int) {
        if currentCount > previousCount {
            self = .up
        } else if currentCount < previousCount {
            self = .down
        } else {
            self = .stale
        }
    }
}

extension Trend {
    var imageName: String {
        switch self {
        case .up:
            "chevron.up.circle.fill"
        case .down:
            "chevron.down.circle.fill"
        case .none, .stale:
            "minus.circle.fill"
        }
    }
}
