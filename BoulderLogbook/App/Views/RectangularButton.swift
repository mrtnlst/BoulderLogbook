//
//  RectangularButton.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let tintColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .background(configuration.isPressed ? tintColor.opacity(0.1) : .background)
            .foregroundStyle(.primaryText)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        tintColor,
                        lineWidth: configuration.isPressed ? 3 : 2
                    )
            )
    }
}


struct RectangularButton: View {
    let title: String
    let image: String
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled: Bool

    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Image(systemName: image)
                    Text(title)
                }
                .frame(maxWidth: .infinity)
                .tracking(1)
                .fontWeight(.medium)
                .textCase(.uppercase)
                .font(.subheadline)
            }
        )
        .opacity(isEnabled ? 1.0 : 0.4)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

extension RectangularButton {
    @ViewBuilder static func save(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Save", image: "checkmark", action: action)
            .buttonStyle(PrimaryButtonStyle(tintColor: .araPrimary))
    }
    @ViewBuilder static func edit(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Edit", image: "pencil", action: action)
            .buttonStyle(PrimaryButtonStyle(tintColor: .araWarning))
    }
    @ViewBuilder static func delete(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Delete", image: "trash", action: action)
            .buttonStyle(PrimaryButtonStyle(tintColor: .araError))
    }
    @ViewBuilder static func cancel(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Cancel", image: "xmark", action: action)
            .buttonStyle(PrimaryButtonStyle(tintColor: .tertiaryText))
    }
}

#Preview {
    PlainList {
        PlainSection("Buttons") {
            RectangularButton.save {}
            RectangularButton.delete {}
            RectangularButton.edit {}
            RectangularButton.cancel {}
        }
    }
}
