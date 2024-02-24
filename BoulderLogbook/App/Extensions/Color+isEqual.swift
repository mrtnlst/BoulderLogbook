//
//  Color+isEqual.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.02.24.
//

import SwiftUI

extension Color {
    func isEqual(to color: Color) -> Bool {
        let color1Components = colorComponents
        let color2Components = color.colorComponents
        return Int((color1Components?.red ?? 0) * 1000) == Int((color2Components?.red ?? 0) * 1000)
            && Int((color1Components?.blue ?? 0) * 1000) == Int((color2Components?.blue ?? 0) * 1000)
            && Int((color1Components?.green ?? 0) * 1000) == Int((color2Components?.green ?? 0) * 1000)
    }
}
