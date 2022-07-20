//
//  BoulderGrade.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import SwiftUI

enum BoulderGrade: Int, Codable, CaseIterable {
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
        case .blue: return .blue
        case .red: return .red
        case .orange: return .orange
        case .black: return .black
        case .white:
            return Color(uiColor: .init(dynamicProvider: { $0.userInterfaceStyle == .light ? .gray : .white }))
        case .yellow: return .yellow
        case .purple: return .purple
        }
    }
    
    static var chartForegroundStyleScale: KeyValuePairs<String, Color> = [
        BoulderGrade.purple.gradeDescription: BoulderGrade.purple.color,
        BoulderGrade.yellow.gradeDescription: BoulderGrade.yellow.color,
        BoulderGrade.white.gradeDescription: BoulderGrade.white.color,
        BoulderGrade.black.gradeDescription: BoulderGrade.black.color,
        BoulderGrade.orange.gradeDescription: BoulderGrade.orange.color,
        BoulderGrade.red.gradeDescription: BoulderGrade.red.color,
        BoulderGrade.blue.gradeDescription: BoulderGrade.blue.color
    ]
}
