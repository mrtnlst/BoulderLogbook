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
}

extension InsightModel {
    static func sessionCount(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "waveform",
            foregroundStyle: .araLightBlue
        )
    }
    
    static func mostCommonWeekday(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "calendar",
            foregroundStyle: .araLightRed
        )
    }
    
    static func mostAscends(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "chart.bar.xaxis.descending",
            foregroundStyle: .araLightYellow
        )
    }
    
    static func selectedAscends(insight: String? = nil) -> Self {
        Self(
            insight: insight,
            systemImage: "flag.pattern.checkered",
            foregroundStyle: nil
        )
    }
}
