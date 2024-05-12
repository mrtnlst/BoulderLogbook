//
//  CreditsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.05.24.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        HStack(alignment: .center) {
            Text("Made with")
            Image("boulder-hold")
                .font(.footnote)
                .padding(.horizontal, -4)
            Text("by Martin")
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.tertiaryText)
        .font(.footnote)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    PlainList {
        CreditsView()
    }
}
