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
        let label = Label {
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
        List {
            Section {
                EmptyMessageView(message: "No entries available")
                    .frame(maxWidth: .infinity)
            }
            Section {
                EmptyMessageView(message: "Create or select grade system from Settings!", action: {})
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
