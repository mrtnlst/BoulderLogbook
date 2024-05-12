//
//  TotalAmountView.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.05.24.
//

import SwiftUI

struct TotalAmountView: View {
    let amount: Int

    var body: some View {
        Text("Total number of entries: \(amount)")
            .foregroundStyle(.tertiaryText)
            .font(.footnote)
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

#Preview {
    PlainList {
        TotalAmountView(amount: 92)
    }
}
