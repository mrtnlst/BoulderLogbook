//
//  RectangularButton.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import SwiftUI

struct RectangularButton: View {
    let title: String
    let image: String
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                HStack {
                    Image(systemName: image)
                    Text(title)
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
            }
        )
        .buttonStyle(.borderedProminent)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

extension RectangularButton {
    @ViewBuilder static func save(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Save", image: "checkmark", action: action)
            .tint(.jadeGreen)
    }
    @ViewBuilder static func edit(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Edit", image: "pencil", action: action)
            .tint(.hunyadiOrange)
    }
    @ViewBuilder static func delete(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Delete", image: "trash", action: action)
            .tint(.indianRed)
    }
    @ViewBuilder static func cancel(action: @escaping () -> Void) -> some View {
        RectangularButton(title: "Cancel", image: "xmark", action: action)
            .tint(.jetBlack)
    }
}

struct RectangularButton_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section{
                Text("Buttons")
            }
            RectangularButton.save {}
            RectangularButton.delete {}
            RectangularButton.edit {}
            RectangularButton.cancel {}
        }
    }
}
