//
//  ShapeStyle+Additions.swift
//  BoulderLogbook
//
//  Created by Martin List on 03.02.24.
//

import SwiftUI

extension ShapeStyle where Self == Color {
    static var primaryText: Color { .araTextPrimary }
    static var primaryTextDark: Color { .araTextPrimaryDark }
    static var secondaryText: Color { .araTextSecondary }
    static var tertiaryText: Color { .araTextTertiary }
    static var background: Color { .araBackground }
    static var rowBackground: Color { .araRowBackground }
    static var success: Color { .araSuccess }
    static var error: Color { .araError }
    static var accent: Color { .araAccent }
}
