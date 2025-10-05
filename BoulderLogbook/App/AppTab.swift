//
//  AppTab.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

enum AppTab: String, CaseIterable {
    case sessions = "Sessions"
    case training = "Training"
    case settings = "Settings"
    
    var symbol: String {
        switch self {
        case .sessions:
            return "figure.play"
        case .training:
            return "figure.strengthtraining.traditional"
        case .settings:
            return "gear"
        }
    }
}
