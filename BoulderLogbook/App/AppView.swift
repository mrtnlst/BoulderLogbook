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
            toolbarContent()
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

private extension AppView {
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: toolbarPlacement) {
            Button {
                store.send(.presentSettings)
            } label: {
                if #available(iOS 26, *) {
                    Label("Settings", systemImage: "gear")
                } else {
                    Image(systemName: "gear")
                        .fontWeight(.bold)
                }
            }
        }
        if #available(iOS 26, *) {
            ToolbarSpacer(.flexible, placement: .bottomBar)
        }
        ToolbarItem(placement: toolbarPlacement) {
            Button {
                store.send(.presentEntryForm(nil))
            } label: {
                if #available(iOS 26, *) {
                    Label("Add entry", systemImage: "plus")
                } else {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    var toolbarPlacement: ToolbarItemPlacement {
        if #available(iOS 26, *) {
            return .bottomBar
        } else {
            return .topBarTrailing
        }
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
