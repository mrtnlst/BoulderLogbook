//
//  AppTab.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

enum AppTab: String, CaseIterable {
    case sessions = "Sessions"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .sessions:
            return "figure.play"
        case .settings:
            return "gear"
        }
    }
}
