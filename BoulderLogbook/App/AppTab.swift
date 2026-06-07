//
//  AppTab.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

enum AppTab: String, CaseIterable {
    case sessions = "Sessions"
    case insights = "Insights"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .sessions:
            return "figure.play"
        case .insights:
            return "lightbulb.max"
        case .settings:
            return "gear"
        }
    }
}
