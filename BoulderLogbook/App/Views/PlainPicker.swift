//
//  PlainPicker.swift
//  BoulderLogbook
//
//  Created by Martin List on 17.01.24.
//

import SwiftUI

struct PlainPicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    let title: String
    let selection: Binding<SelectionValue>
    @ViewBuilder let content: () -> Content

    init(title: String, selection: Binding<SelectionValue>, content: @escaping () -> Content) {
        self.title = title
        self.selection = selection
        self.content = content
        UISegmentedControl.appearance()
            .backgroundColor = UIColor(Color.araRowBackground)
        UISegmentedControl.appearance()
            .selectedSegmentTintColor = UIColor(Color.araPrimary)
        UISegmentedControl.appearance()
            .setTitleTextAttributes(
                [.foregroundColor: UIColor(Color.araTextPrimary)], for: .normal
            )
        UISegmentedControl.appearance()
            .setTitleTextAttributes(
                [.foregroundColor: UIColor(Color.araTextPrimary)], for: .selected
            )
    }

    var body: some View {
        Picker(title, selection: selection, content: content)
        .pickerStyle(.segmented)
    }
}

#Preview {
    @Previewable @State var selection = "Hello"
    let choices = ["Hello", "World", "Swift"]
    return PlainList {
        PlainPicker(
            title: "Title",
            selection: $selection) {
                ForEach(choices, id: \.self) {
                    Text($0)
                }
            }
    }
}
