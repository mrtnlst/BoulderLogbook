//
//  ExerciseSymbol.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

enum ExerciseSymbol: String, CaseIterable {
    case play = "figure.play"
    case core = "figure.core.training"
    case running = "figure.run"
    case functionalStrength = "figure.strengthtraining.functional"
    case cross = "figure.cross.training"
    case cardio = "figure.mixed.cardio"
    case highIntensity = "figure.highintensity.intervaltraining"
    case traditionalStrength = "figure.strengthtraining.traditional"
    case yoga = "figure.yoga"
    
    var description: String {
        switch self {
        case .play:
            return "Pull-up"
        case .core:
            return "Core training"
        case .running:
            return "Running"
        case .functionalStrength:
            return "Functional strength"
        case .cross:
            return "Cross-training"
        case .cardio:
            return "Cardio"
        case .highIntensity:
            return "HIIT"
        case .traditionalStrength:
            return "Traditional strength"
        case .yoga:
            return "Yoga"
        }
    }
}
