//
//  LegacyBoulderGrade.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import SwiftUI

enum LegacyBoulderGrade: Int, Codable, CaseIterable {
    case blue
    case red
    case orange
    case black
    case white
    case yellow
    case purple
    
    var gradeDescription: String {
        switch self {
        case .blue: return "Blue"
        case .red: return "Red"
        case .orange: return "Orange"
        case .black: return "Black"
        case .white: return "White"
        case .yellow: return "Yellow"
        case .purple: return "Purple"
        }
    }
    
    var color: Color {
        switch self {
        case .blue: return .mandalaBlue
        case .red: return .mandalaRed
        case .orange: return .mandalaOrange
        case .black: return .mandalaBlack
        case .white: return .mandalaWhite
        case .yellow: return .mandalaYellow
        case .purple: return .mandalaPurple
        }
    }
    
    static var chartForegroundStyleScale: KeyValuePairs<String, Color> = [
        LegacyBoulderGrade.purple.gradeDescription: LegacyBoulderGrade.purple.color,
        LegacyBoulderGrade.yellow.gradeDescription: LegacyBoulderGrade.yellow.color,
        LegacyBoulderGrade.white.gradeDescription: LegacyBoulderGrade.white.color,
        LegacyBoulderGrade.black.gradeDescription: LegacyBoulderGrade.black.color,
        LegacyBoulderGrade.orange.gradeDescription: LegacyBoulderGrade.orange.color,
        LegacyBoulderGrade.red.gradeDescription: LegacyBoulderGrade.red.color,
        LegacyBoulderGrade.blue.gradeDescription: LegacyBoulderGrade.blue.color
    ]
}
