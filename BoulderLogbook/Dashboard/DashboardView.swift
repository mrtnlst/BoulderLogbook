//
//  DashboardView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct DashboardView: View {
    @Bindable var store: StoreOf<Dashboard>
    
    var body: some View {
        NavigationStack {
            PlainList {
                trendsView
            }
            .onAppear {
                store.send(.onAppear)
            }
            .navigationTitle("Dashboard")
            .toolbarTitleDisplayMode(.inlineLarge)
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
        }
    }
}

private extension DashboardView {
    var trendsView: some View {
        PlainSection("Trends") {
            TrendsView(
                store: store.scope(
                    \.trends,
                     action: \.trends
                )
            )
        }
    }

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
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
}

#Preview {
    NavigationStack {
        DashboardView(
            store: Store(
                initialState: Dashboard.State(
                    sections: Shared(
                        value: Logbook.sample2.sections
                    )
                )
            ) {
                Dashboard()
            }
        )
    }
}
