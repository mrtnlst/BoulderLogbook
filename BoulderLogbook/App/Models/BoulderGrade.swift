//
//  BoulderGrade.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation

enum BoulderGrade: Int, Codable, CaseIterable {
    case blue
    case red
    case orange
    case black
    case white
    case yellow
    
    var gradeDescription: String {
        switch self {
        case .blue: return "Blue"
        case .red: return "Red"
        case .orange: return "Orange"
        case .black: return "Black"
        case .white: return "White"
        case .yellow: return "Yellow"
        }
    }
}
