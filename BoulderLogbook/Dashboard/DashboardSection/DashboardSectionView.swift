//
//  DashboardSectionView.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import SwiftUI
import ComposableArchitecture

struct DashboardSectionView: View {
    let store: StoreOf<DashboardSection>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Section {
                ForEach(viewStore.entryDetailStates) { entryDetailState in
                    Button(
                        action: {
                            viewStore.send(.setNavigation(entryDetailState.id))
                        },
                        label: {
                            DashboardEntryView(
                                entry: entryDetailState.entry,
                                gradeSystem: entryDetailState.gradeSystem
                            )
                        }
                    )
                    .swipeActions {
                        Button(role: .destructive) {
                            viewStore.send(.delete(entryDetailState.id))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.indianRed)
                        Button {
                            viewStore.send(.edit(entryDetailState.entry))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.hunyadiOrange)
                    }
                }
            } header: {
                Text(
                    viewStore.date,
                    format: .dateTime.year().month(.wide)
                )
            }
            .headerProminence(.increased)
        }
        .navigationDestination(
            store: store.scope(state: \.$entryDetail, action: { .entryDetail($0) })
        ) {
            EntryDetailView(store: $0)
        }
    }
}

struct DashboardSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                DashboardSectionView(
                    store: Store(
                        initialState: DashboardSection.State(
                            date: .now,
                            entries: .samples,
                            gradeSystems: [.mandala]
                        ),
                        reducer: DashboardSection()
                    )
                )
            }
        }
    }
}
