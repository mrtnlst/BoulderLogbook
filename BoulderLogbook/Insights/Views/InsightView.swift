//
//  InsightView.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.09.26.
//

import SwiftUI

struct InsightView: View {
    let model: InsightModel

    var body: some View {
        Label {
            if let sessionCountInsight = model.insight {
                Text(sessionCountInsight)
            } else {
                LoadingIndicator()
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

#Preview {
    PlainList {
        InsightView(model: .sessionCount())
        InsightView(model: .sessionCount(insight: "Some fact"))
    }
}
