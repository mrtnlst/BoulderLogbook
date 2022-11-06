//
//  ChartState+Segment.swift
//  BoulderLogbook
//
//  Created by Martin List on 01.10.22.
//

import Foundation

extension ChartState {
    enum Segment: String, Equatable {
        case week = "7 Days"
        case month = "30 Days"
        case all = "All-time"
        
        var tag: Int {
            switch self {
            case .week:
                return 7
            case .month:
                return 30
            case .all:
                return 100
            }
        }
    }
}
