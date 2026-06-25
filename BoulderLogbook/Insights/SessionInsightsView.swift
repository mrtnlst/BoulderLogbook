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
            if let sessionCountInsight = store.sessionCountInsight {
                Text(sessionCountInsight)
            } else {
                LoadingIndicator()
            }
        } icon: {
            Image(systemName: "waveform")
                .foregroundStyle(Color.araLightBlue)
        }
        Label {
            if let mostCommonWeekdayInsight = store.mostCommonWeekdayInsight {
                Text(mostCommonWeekdayInsight)
            } else {
                LoadingIndicator()
            }
        } icon: {
            Image(systemName: "calendar")
                .foregroundStyle(Color.araLightRed)
        }
    }
}
