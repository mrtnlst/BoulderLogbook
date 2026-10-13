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
            PlainRowButton {
                send(.didTapMostAscendsButton)
            } label: {
                InsightView(model: store.mostAscends)
            }
            InsightView(model: store.selectedAscends) {
                Button {
                    send(.didTapSelectFocusGrade)
                } label: {
                    Image(systemName: "gear")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.accent)
            }
        }
        .task { send(.task) }
    }
}
