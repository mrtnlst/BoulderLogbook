//
//  KeypadButtonStyle.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.10.26.
//

import SwiftUI

struct KeypadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .foregroundStyle(.primaryText)
            .background {
                if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.araBackground)
                }
            }
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(
                .easeOut(duration: 0.2),
                value: configuration.isPressed
            )
    }
}

extension ButtonStyle where Self == KeypadButtonStyle {
    static var keypad: KeypadButtonStyle { .init() }
}
