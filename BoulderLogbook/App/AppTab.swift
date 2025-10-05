//
//  AppTab.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

enum AppTab: String, CaseIterable {
    case training = "Training"
    case exercise = "Exercise"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .training:
            return "figure.play"
        case .exercise:
            return "figure.strengthtraining.traditional"
        case .settings:
            return "gear"
        }
    }
}
