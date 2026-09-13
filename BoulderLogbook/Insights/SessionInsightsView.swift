//
//  SessionInsightsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: SessionInsightsFeature.self)
struct SessionInsightsView: View {
    let store: StoreOf<SessionInsightsFeature>
    
    var body: some View {
        Group {
            InsightView(model: store.sessionCountInsight)
            InsightView(model: store.mostCommonWeekdayInsight)
        }
        .task { send(.task) }
    }
}
