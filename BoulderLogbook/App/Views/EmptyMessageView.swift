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
    let action: (() -> Void)?
    
    init(message: String?, action: (() -> Void)? = nil) {
        self.message = message
        self.action = action
    }
    
    var body: some View {
        let label = HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 7 * size)
                    .frame(width: 28 * size, height: 28 * size)
                    .foregroundColor(.araError)
                Image(systemName: "exclamationmark")
                    .foregroundStyle(.primaryText)
            }
            Text(message ?? "")
        }
            .font(.callout)
            .fontWeight(.medium)
        
        if let action = action {
            Button {
                action()
            } label: {
                label
            }
            .buttonStyle(.plain)
        } else {
            label
        }
    }
}

struct EmptyMessageView_Previews: PreviewProvider {
    static var previews: some View {
        PlainList {
            PlainSection("Empty") {
                EmptyMessageView(message: "No entries available")
                    .frame(maxWidth: .infinity)
            }
            PlainSection("More Text") {
                EmptyMessageView(message: "Create or select grade system from Settings!", action: {})
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
