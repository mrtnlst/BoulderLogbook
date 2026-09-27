//
//  InsightView.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.09.26.
//

import SwiftUI

struct InsightView<Accessory: View>: View {
    let model: InsightModel
    @ViewBuilder let accessoryView: (() -> Accessory)?

    init(
        model: InsightModel,
        accessoryView: (() -> Accessory)? = nil
    ) {
        self.model = model
        self.accessoryView = accessoryView
    }
    
    var body: some View {
        Label {
            HStack {
                if let sessionCountInsight = model.insight {
                    Text(sessionCountInsight)
                } else {
                    LoadingIndicator()
                }
                Spacer()
                accessoryView?()
                
                if model.hasChevron {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondaryText)
                }
            }
        } icon: {
            let image = Image(systemName: model.systemImage)
            if let foregroundStyle = model.foregroundStyle {
                image
                    .foregroundStyle(foregroundStyle)
            } else {
                image
            }
        }
    }
}

extension InsightView {
    init(model: InsightModel) where Accessory == EmptyView {
        self.init(model: model,accessoryView: nil)
    }
}

#Preview {
    PlainList {
        InsightView(model: .sessionCount())
        InsightView(model: .sessionCount(insight: "Some fact"))
    }
}
