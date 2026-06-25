//
//  AscendInsightsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import SwiftUI
import ComposableArchitecture

struct AscendInsightsView: View {
    let store: StoreOf<AscendInsightsFeature>
    
    var body: some View {
        Label {
            if let gradeWithMostAscendsInsight = store.gradeWithMostAscendsInsight {
                Text(gradeWithMostAscendsInsight)
            } else {
                LoadingIndicator()
            }
        } icon: {
            Image(systemName: "chart.bar.xaxis.descending")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.araLightYellow, Color.white)
        }
    }
}
