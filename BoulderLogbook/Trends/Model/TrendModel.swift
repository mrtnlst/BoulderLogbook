//
//  GymFrequency.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.09.26.
//

import Foundation

struct TrendModel {
    let category: String
    let trend: Trend
    let count: Int
    
    var text: String {
        switch trend {
        case .none: "-/week"
        default: "\(count)/week"
        }
    }
}

extension TrendModel {
    static func gymFrequency(trend: Trend = .none, count: Int = 0) -> Self {
        .init(
            category: "Gym Frequency",
            trend: trend,
            count: count
        )
    }
    static func ascendsOfGrade(
        category: String = "Ascends of Focus Grade",
        trend: Trend = .none,
        count: Int = 0
    ) -> Self {
        .init(
            category: category,
            trend: trend,
            count: count
        )
    }
}
