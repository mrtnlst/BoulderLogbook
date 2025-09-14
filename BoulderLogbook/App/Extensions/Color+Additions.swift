//
//  Color+Mandala.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation
import SwiftUI

// MARK: - Colors
extension Color {
    // Colors
    static let araBlack = Color(#colorLiteral(red: 0.07058823529, green: 0.07450980392, blue: 0.09019607843, alpha: 1)) // #121317
    static let araDarkBlue = Color(#colorLiteral(red: 0.1568627451, green: 0.1843137255, blue: 0.337254902, alpha: 1)) // #282F56
    static let araBlue = Color(#colorLiteral(red: 0.3411764706, green: 0.5647058824, blue: 0.9176470588, alpha: 1)) // #5790EA
    static let araLightBlue = Color(#colorLiteral(red: 0.4196078431, green: 0.7215686275, blue: 0.9960784314, alpha: 1)) // #6BB8FE
    static let araTurquoise = Color(#colorLiteral(red: 0.4980392157, green: 0.9137254902, blue: 0.9215686275, alpha: 1)) // #7FE9EB
    static let araBrown = Color(#colorLiteral(red: 0.4352941176, green: 0.1568627451, blue: 0.1529411765, alpha: 1)) // #6F2827
    static let araRed = Color(#colorLiteral(red: 0.8980392157, green: 0.3960784314, blue: 0.3960784314, alpha: 1)) // #E56565
    static let araLightRed = Color(#colorLiteral(red: 1, green: 0.5176470588, blue: 0.5294117647, alpha: 1)) // #FF8487
    static let araGreen = Color(#colorLiteral(red: 0.05098039216, green: 0.5960784314, blue: 0.4078431373, alpha: 1)) // #0D9868
    static let araLightGreen = Color(#colorLiteral(red: 0.1019607843, green: 0.8784313725, blue: 0.5921568627, alpha: 1)) // #1AE097
    static let araOrange = Color(#colorLiteral(red: 0.9882352941, green: 0.631372549, blue: 0.4, alpha: 1)) // #FCA166
    static let araYellow = Color(#colorLiteral(red: 1, green: 0.7647058824, blue: 0.3215686275, alpha: 1)) // #FFC352
    static let araLightYellow = Color(#colorLiteral(red: 1, green: 0.9411764706, blue: 0.4862745098, alpha: 1)) // #FFF07C
    static let araPurple = Color(#colorLiteral(red: 0.8392156863, green: 0.3333333333, blue: 0.9294117647, alpha: 1)) // #D655ED
    static let araLightPurple = Color(#colorLiteral(red: 0.8588235294, green: 0.5019607843, blue: 0.7058823529, alpha: 1)) // #DB80B4

    // Main
    static let araPrimary = araPurple
    static let araAccent = araLightGreen

    // Text
    static let araTextPrimary = Color(#colorLiteral(red: 0.9607843137, green: 0.9764705882, blue: 0.9843137255, alpha: 1)) // #F5F9FB
    static let araTextPrimaryDark = Color(#colorLiteral(red: 0.07058823529, green: 0.07450980392, blue: 0.09019607843, alpha: 1)) // #121317
    static let araTextSecondary = Color(#colorLiteral(red: 0.7450980392, green: 0.8039215686, blue: 0.8509803922, alpha: 1)) // #BECDD9
    static let araTextTertiary = Color(#colorLiteral(red: 0.3647058824, green: 0.4235294118, blue: 0.462745098, alpha: 1)) // #5D6C76

    // Backgrounds
    static let araBackground = Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1176470588, alpha: 1)) // #1A1B1E
    static let araRowBackground = Color(#colorLiteral(red: 0.1450980392, green: 0.1529411765, blue: 0.1803921569, alpha: 1)) // #25272E

    // Feedback
    static let araWarning = araYellow
    static let araError = araRed
    static let araHint = araBlue
    static let araSuccess = araGreen

    // Dark Theme
    static let araDeepBlack = Color(#colorLiteral(red: 0.05098039216, green: 0.05490196078, blue: 0.06666666667, alpha: 1)) // #0D0E11
    static let araOffBlack = Color(#colorLiteral(red: 0.07058823529, green: 0.07450980392, blue: 0.09019607843, alpha: 1)) // #121317
    static let araDark = Color(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1176470588, alpha: 1)) // #1A1B1E
    static let araDarkGray = Color(#colorLiteral(red: 0.1450980392, green: 0.1529411765, blue: 0.1803921569, alpha: 1)) // #25272E
    static let araMidGray = Color(#colorLiteral(red: 0.1960784314, green: 0.2078431373, blue: 0.2352941176, alpha: 1)) // #32353C
    static let araLightGray = Color(#colorLiteral(red: 0.2392156863, green: 0.2470588235, blue: 0.2705882353, alpha: 1)) // #3D3F45
}

extension Color {
    static let mandalaBlue = araHint
    static let mandalaRed = araError
    static let mandalaOrange = araYellow
    static let mandalaBlack = araOffBlack
    static let mandalaWhite = araTextPrimary
    static let mandalaYellow = araLightYellow
    static let mandalaPurple = araPrimary
}

// MARK: - araAll
extension Color {
    static var araAll: [Color] = [
        .araMidGray,
        .araDarkBlue,
        .araBlue,
        .araLightBlue,
        .araTurquoise,
        .araGreen,
        .araLightGreen,
        .araLightYellow,
        .araYellow,
        .araOrange,
        .araLightRed,
        .araRed,
        .araBrown,
        .araLightPurple,
        .araPurple,
        .araTextPrimary
    ]
}

// MARK: - isBright
extension Color {
    var isBright: Bool {
        var white: CGFloat = 0.0
        let uiColor = UIColor(self)
        uiColor.getWhite(&white, alpha: nil)
        return white >= 0.85 // Don't use white background
    }
}

// MARK: - isEqual
extension Color {
    func isEqual(to color: Color) -> Bool {
        let color1Components = colorComponents
        let color2Components = color.colorComponents
        return Int((color1Components?.red ?? 0) * 1000) == Int((color2Components?.red ?? 0) * 1000)
            && Int((color1Components?.blue ?? 0) * 1000) == Int((color2Components?.blue ?? 0) * 1000)
            && Int((color1Components?.green ?? 0) * 1000) == Int((color2Components?.green ?? 0) * 1000)
    }
}

// MARK: - iOS 26
extension Color {
    static var toolbarButtonColor: Color? {
        if #available(iOS 26, *) {
            return nil
        } else {
            return .araTextPrimary
        }
    }
}
