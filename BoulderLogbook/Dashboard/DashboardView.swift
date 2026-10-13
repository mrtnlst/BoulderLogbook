//
//  DashboardView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: Dashboard.self)
struct DashboardView: View {
    @Bindable var store: StoreOf<Dashboard>
    
    var body: some View {
        NavigationStack {
            PlainList {
                trendsView
            }
            .navigationTitle("Dashboard")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                toolbarContent()
            }
            .sheet(
                item: $store.scope(
                    state: \.destination?.newEntry,
                    action:  \.destination.newEntry
                )
            ) {
                NewEntryView(store: $0)
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
                send(.presentNewEntry)
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
    @Shared(.fileStorage(.defaultGradeSystem))
    var gradeSystem: GradeSystem = .mandala2
    let _ = $gradeSystem.withLock { $0 = .mandala2 }
    
    NavigationStack {
        DashboardView(
            store: Store(
                initialState: Dashboard.State(
                    sections: Shared(
                        value: Logbook.sample2.sections
                    ),
                    gradeSystems: Shared(value: [.mandala2])
                )
            ) {
                Dashboard()
            }
        )
    }
}
