//
//  AppView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    @Bindable var store: StoreOf<AppReducer>

    var body: some View {
        TabView(selection: $store.tab.sending(\.didChangeTab)) {
            Tab(
                AppTab.sessions.rawValue,
                systemImage: AppTab.sessions.symbol,
                value: AppTab.sessions
            ) {
                DashboardView(
                    store: store.scope(
                        state: \.dashboard,
                        action: \.dashboard
                    )
                )
            }
            Tab(
                AppTab.training.rawValue,
                systemImage: AppTab.training.symbol,
                value: AppTab.training
            ) {
                NavigationStack {
                    Text("Coming Soon")
                        .navigationTitle("Training")
                        .toolbarTitleDisplayMode(.inlineLarge)
                }
            }
            Tab(
                AppTab.settings.rawValue,
                systemImage: AppTab.settings.symbol,
                value: AppTab.settings
            ) {
                SettingsView(
                    store: store.scope(
                        state: \.settings,
                        action: \.settings
                    )
                )
            }
        }
        .tint(.toolbarButtonColor)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        AppView(
            store: Store(
                initialState: AppReducer.State()
            ) {
                AppReducer()
            }
        )
    }
}
