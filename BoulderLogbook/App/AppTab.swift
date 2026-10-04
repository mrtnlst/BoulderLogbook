//
//  AppTab.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

enum AppTab: String, CaseIterable {
    case sessions = "Sessions"
    case insights = "Insights"
    case history = "History"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .sessions:
            return "figure.play"
        case .insights:
            return "lightbulb.max"
        case .history:
            return "text.book.closed"
        case .settings:
            return "gear"
        }
    }
}
