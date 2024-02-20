//
//  PlainSection.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.01.24.
//

import SwiftUI

struct PlainSection<Content: View, Header: View>: View {
    let title: String?
    let content: () -> Content
    let header: (() -> Header)?

    init(
        _ title: String? = nil,
        @ViewBuilder content: @escaping () -> Content,
        header: (() -> Header)?
    ) {
        self.title = title
        self.content = content
        self.header = header
    }

    var body: some View {
        Section {
            if let title {
                Text(title)
                    .fontWeight(.semibold)
                    .listRowBackground(Color.background)
            }
            header?()
                .listRowBackground(Color.background)
            content()
        }
    }
}

extension PlainSection {
    init(
        _ title: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) where Header == EmptyView {
        self.init(title, content: content, header: nil)
    }
}

#Preview {
    PlainList {
        PlainSection("Section") {
            Text("Text")
            Text("Text 2")
        }
        PlainSection {
            Text("Text 3")
            Text("Text 4")
        }
        PlainSection {
            Text("Text")
        } header: {
            Text(Date(), format: .dateTime)
                .fontWeight(.semibold)
        }
    }
}
