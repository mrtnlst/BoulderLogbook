//
//  Color+Mandala.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation
import SwiftUI

extension Color {
    static let jadeGreen = Color(#colorLiteral(red: 0.3411764706, green: 0.6549019608, blue: 0.4509803922, alpha: 1))
    static let indianRed = Color(#colorLiteral(red: 0.8549019608, green: 0.3333333333, blue: 0.3215686275, alpha: 1))
    static let jetBlack = Color(#colorLiteral(red: 0.2117647059, green: 0.2117647059, blue: 0.2117647059, alpha: 1))
    static let hunyadiOrange = Color(#colorLiteral(red: 0.9960784314, green: 0.7254901961, blue: 0.3725490196, alpha: 1))
    static let blueDeFrance = Color(#colorLiteral(red: 0.1882352941, green: 0.5137254902, blue: 0.862745098, alpha: 1))
}

extension Color {
    static let mandalaBlue = Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    static let mandalaRed = Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    static let mandalaOrange = Color(#colorLiteral(red: 0.9803921569, green: 0.6392156863, blue: 0.1411764706, alpha: 1))
    static let mandalaBlack = Color(#colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1))
    static let mandalaWhite = Color(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1))
    static let mandalaYellow = Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
    static let mandalaPurple = Color(#colorLiteral(red: 0.7921568627, green: 0.3764705882, blue: 0.9490196078, alpha: 1))
}

extension Color {
    var isBright: Bool {
        var white: CGFloat = 0.0
        let uiColor = UIColor(self)
        uiColor.getWhite(&white, alpha: nil)
        return white >= 0.85 // Don't use white background
    }
}
