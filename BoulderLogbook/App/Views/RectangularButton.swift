//
//  RectangularButton.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import SwiftUI

struct RectangularButton: View {
    let title: String
    let titleColor: Color
    let image: String
    let action: () -> Void
    
    internal init(title: String, titleColor: Color = .white, image: String, action: @escaping () -> Void) {
        self.title = title
        self.titleColor = titleColor
        self.image = image
        self.action = action
    }

    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Image(systemName: image)
                    Text(title)
                }
                .foregroundColor(titleColor)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
    }
}

extension RectangularButton {
    @ViewBuilder static func save(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Save", image: "checkmark", action: action)
            .tint(.darkPastelGreen)
    }
    @ViewBuilder static func edit(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Edit", image: "pencil", action: action)
            .tint(.pumpkin)
    }
    @ViewBuilder static func delete(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Delete", image: "trash", action: action)
            .tint(.redPantone)
    }
    @ViewBuilder static func cancel(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Cancel", titleColor: .black, image: "xmark", action: action)
            .tint(.ashGray)
    }
}

struct RectangularButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            RectangularButton.save {}
            RectangularButton.delete {}
            RectangularButton.edit {}
            RectangularButton.cancel {}
            RectangularButton(title: "Primary", image: "", action: {})
                .tint(.accentColor)
            Spacer()
        }
        .padding()
    }
}
