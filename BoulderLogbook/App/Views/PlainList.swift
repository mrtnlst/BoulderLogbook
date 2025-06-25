//
//  PlainList.swift
//  BoulderLogbook
//
//  Created by Martin List on 17.01.24.
//

import SwiftUI

struct PlainList<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        List {
            content()
                .listRowBackground(Color.rowBackground)
                .foregroundStyle(.primaryText)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .background(Color.background)
        .foregroundStyle(.primaryText)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .listRowSpacing(0)
        .listSectionSpacing(16)
    }
}

#Preview {
    PlainList {
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
        PlainSection {
            RectangularButton.save {}
            RectangularButton.cancel {}
        }
    }
}
