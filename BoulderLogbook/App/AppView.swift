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
        DashboardView(
            store: store.scope(
                state: \.dashboard,
                action: \.dashboard
            )
        )
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    store.send(.presentSettings)
                } label: {
                    Image(systemName: "gear")
                        .fontWeight(.bold)
                }
            }
            ToolbarSpacer(.flexible, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button {
                    store.send(.presentEntryForm(nil))
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.entryForm,
                action:  \.destination.entryForm
            )
        ) {
            EntryFormView(store: $0)
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.settings,
                action: \.destination.settings
            )
        ) {
            SettingsView(store: $0)
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppReducer.State()
        ) {
            AppReducer()
        }
    )
}
