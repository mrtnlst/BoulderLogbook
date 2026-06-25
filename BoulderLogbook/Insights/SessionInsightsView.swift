//
//  SessionInsightsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import SwiftUI
import ComposableArchitecture

struct SessionInsightsView: View {
    let store: StoreOf<SessionInsightsFeature>
    
    var body: some View {
        Label {
            Text(store.sessionCountInsight)
        } icon: {
            Image(systemName: "waveform")
                .foregroundStyle(Color.araLightBlue)
        }
        Label {
            Text(store.mostCommonWeekdayInsight)
        } icon: {
            Image(systemName: "calendar")
                .foregroundStyle(Color.araLightRed)
        }
    }
}
