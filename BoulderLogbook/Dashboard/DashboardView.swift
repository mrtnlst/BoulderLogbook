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
                if viewStore.entryStates.count > 2 {
                    diagramView()
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
    
    @ViewBuilder func diagramView() -> some View {
        Section {
            WithViewStore(store) { viewStore in
                DiagramView(
                    store: store.scope(
                        state: \.diagramState,
                        action: Dashboard.Action.diagram
                    )
                )
                .onLongPressGesture(
                    minimumDuration: 0.2,
                    perform: {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        viewStore.send(.presentFilters)
                    }
                )
            }
        }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DashboardView(
                store: Store(
                    initialState: Dashboard.State(.sample),
                    reducer: Dashboard()
                )
            )
        }
    }
}
