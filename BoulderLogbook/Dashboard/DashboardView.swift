//
//  DashboardView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct DashboardView: View {
    let store: StoreOf<Dashboard>
    
    var body: some View {
        listView()
            .navigationDestination(
                for: StoreOf<EntryDetail>.self
            ) { detailStore in
                EntryDetailView(store: detailStore)
            }
    }
}

extension DashboardView {
    @ViewBuilder func listView() -> some View {
        WithViewStore(store) { viewStore in
            List {
                IfLetStore(
                    store.scope(
                        state: \.diagramPage,
                        action: Dashboard.Action.diagramPage
                    )
                ) { diagramPageStore in
                    DiagramPageView(store: diagramPageStore)
                }
                ForEachStore(
                    store.scope(
                        state: \.sections,
                        action: Dashboard.Action.dashboardSection(id:action:)
                    )
                ) { sectionStore in
                    DashboardSectionView(store: sectionStore)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle("Dashboard")
        }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardView(
                store: Store(
                    initialState: Dashboard.State(),
                    reducer: Dashboard()
                        .dependency(\.entryClient, .previewValue)
                        .dependency(\.gradeSystemClient, .previewValue)
                )
            )
        }
    }
}
