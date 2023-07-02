//
//  EmptyMessageView.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import SwiftUI

struct EmptyMessageView: View {
    @ScaledMetric var size: CGFloat = 1
    let message: String?
    
    var body: some View {
        Label {
            Text(message ?? "")
        } icon: {
            ZStack {
                RoundedRectangle(cornerRadius: 7 * size)
                    .frame(width: 28 * size, height: 28 * size)
                    .foregroundColor(.indianRed)
                Image(systemName: "exclamationmark")
                    .foregroundColor(.white)
            }
        }
        .font(.callout)
        .fontWeight(.medium)
    }
}

struct EmptyMessageView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EmptyMessageView(message: "No entries available")
                .frame(maxWidth: .infinity)
        }
    }
}
