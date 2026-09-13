//
//  AscendInsightsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: AscendInsightsFeature.self)
struct AscendInsightsView: View {
    @Bindable var store: StoreOf<AscendInsightsFeature>
    
    var body: some View {
        Group {
            InsightView(model: store.mostAscends)
            selectedAscendsView
        }
        .task { send(.task) }
    }
}

private extension AscendInsightsView {
    var selectedAscendsView: some View {
        Label {
            if let grades = store.gradeSystem?.grades,
               let insight = store.selectedAscends.insight {
                HStack {
                    Text(insight)
                    Spacer()
                    Picker(
                        "",
                        selection: $store.selectedAscendedGrade.sending(\.setSelectedGrade)
                    ) {
                        Text("None")
                            .tag(Grade?.none)
                        ForEach(grades) {
                            Text("Grade \($0.name)")
                                .tag($0)
                        }
                    }
                    .tint(.accent)
                }
            } else {
                LoadingIndicator()
            }
        } icon: {
            Image(systemName: store.selectedAscends.systemImage)
        }
    }
}
