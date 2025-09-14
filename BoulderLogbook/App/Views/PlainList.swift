//
//  PlainList.swift
//  BoulderLogbook
//
//  Created by Martin List on 17.01.24.
//

import SwiftUI

struct PlainList<Content: View>: View {
    var hideSeperator: Bool
    @ViewBuilder let content: () -> Content

    init(
        hideSeperator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.hideSeperator = hideSeperator
        self.content = content
    }

    var body: some View {
        List {
            content()
                .listRowBackground(Color.rowBackground)
                .foregroundStyle(.primaryText)
                .listRowSeparator(hideSeperator ? .hidden : .visible)
                .listRowSeparatorTint(.araBackground)
                .listSectionSeparator(.hidden)
        }
        .listStyle(.plain)
        .background(Color.background)
        .foregroundStyle(.primaryText)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    PlainList(hideSeperator: false) {
        PlainSection("Section 1") {
            Label("Date", systemImage: "calendar")
            Label("Gears", systemImage: "gear")
        }
        PlainSection("Section 2") {
            Label("Date", systemImage: "calendar")
            Label("Gears", systemImage: "gear")
        }
        PlainSection {
            Label("Date", systemImage: "calendar")
            Label("Gears", systemImage: "gear")
        }
    }
}
