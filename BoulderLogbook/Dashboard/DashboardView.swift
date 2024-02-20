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
        WithViewStore(store, observe: { $0 }) { viewStore in
            PlainList {
                DiagramPageView(
                    store: store.scope(
                        state: \.diagramPage,
                        action: \.diagramPage
                    )
                )
                ForEachStore(
                    store.scope(
                        state: \.sections,
                        action: \.dashboardSection
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
                    initialState: Dashboard.State()
                ) {
                    Dashboard()
                        .dependency(\.entryClient, .previewValue)
                        .dependency(\.gradeSystemClient, .previewValue)
                }
            )
        }
    }
}
