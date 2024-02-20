//
//  LoadingIndicator.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import SwiftUI

struct LoadingIndicator: View {
    var body: some View {
        HStack(spacing: 8) {
            ProgressView()
                .tint(.araTextPrimary)
            Text("Fetching data ...")
                .font(.callout)
                .fontWeight(.medium)
        }
        .foregroundStyle(.primaryText)
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PlainList {
            LoadingIndicator()
        }
    }
}
