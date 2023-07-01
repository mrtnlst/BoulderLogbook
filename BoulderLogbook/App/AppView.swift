//
//  AppView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppReducer>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            DashboardView(
                store: store.scope(state: \.dashboard, action: AppReducer.Action.dashboard)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewStore.send(.presentSettings)
                    } label: {
                        Image(systemName: "gear")
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.presentEntryForm)
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .sheet(
                store: store.scope(state: \.$destination, action: { .destination($0) }),
                state: /AppReducer.Destination.State.entryForm,
                action: AppReducer.Destination.Action.entryForm
            ) {
                EntryFormView(store: $0)
            }
            .sheet(
                store: store.scope(state: \.$destination, action: { .destination($0) }),
                state: /AppReducer.Destination.State.settings,
                action: AppReducer.Destination.Action.settings
            ) {
                SettingsView(store: $0)
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: AppReducer.State(),
                reducer: AppReducer()
            )
        )
    }
}
