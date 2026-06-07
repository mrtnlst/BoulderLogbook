//
//  InsightsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.06.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: InsightsFeature.self)
struct InsightsView: View {
    @Bindable var store: StoreOf<InsightsFeature>

    var body: some View {
        NavigationStack {
            VStack {
                picker
                PlainList {
                }
            }
            .navigationTitle("Insights")
            .toolbarTitleDisplayMode(.inlineLarge)
            .task { send(.task) }
        }
        .preferredColorScheme(.dark)
    }
}

private extension InsightsView {
    @MainActor
    var picker: some View {
        Picker(
            "Select time frame",
            selection: $store.selectedSegment
        ) {
            ForEach(InsightsFeature.TimeSegment.allCases, id: \.self) { segment in
                Text(segment.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    InsightsView(
        store: Store(
            initialState: .init(),
            reducer: {
                InsightsFeature()
            }
        )
    )
}
