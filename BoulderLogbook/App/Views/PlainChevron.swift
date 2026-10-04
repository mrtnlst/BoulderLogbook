//
//  PlainChevron.swift
//  BoulderLogbook
//
//  Created by Martin List on 04.10.26.
//

import SwiftUI

struct PlainChevron: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(.secondaryText)
            .font(.footnote)
            .fontWeight(.semibold)
    }
}
