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
            Text("Fetching data ...")
                .font(.callout)
                .fontWeight(.medium)
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
