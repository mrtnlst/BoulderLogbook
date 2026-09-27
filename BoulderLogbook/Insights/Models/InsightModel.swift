//
//  InsightModel.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.09.26.
//

import SwiftUI

struct InsightModel {
    let insight: String?
    let systemImage: String
    let foregroundStyle: Color?
    let hasChevron: Bool
}

extension InsightModel {
    static func sessionCount(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "waveform",
            foregroundStyle: .araLightBlue,
            hasChevron: true
        )
    }
    
    static func mostCommonWeekday(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "calendar",
            foregroundStyle: .araLightRed,
            hasChevron: false
        )
    }
    
    static func mostAscends(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "chart.bar.xaxis.descending",
            foregroundStyle: .araLightYellow,
            hasChevron: true
        )
    }
    
    static func selectedAscends(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "flag.pattern.checkered",
            foregroundStyle: nil,
            hasChevron: false
        )
    }
}
