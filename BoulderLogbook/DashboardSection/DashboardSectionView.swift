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
                ForEachStore(
                    store.scope(
                        state: \.entryStates,
                        action: DashboardSection.Action.entryDetail(id:action:))
                ) { entryStore in
                    NavigationLink(value: entryStore) {
                        let entry = ViewStore(entryStore).entry
                        if let gradeSystem = viewStore.gradeSystems.first { $0.id == entry.gradeSystem } {
                            DashboardEntryView(
                                entry: entry,
                                gradeSystem: gradeSystem
                            )
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewStore.send(.delete(ViewStore(entryStore).entry.id))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            viewStore.send(.edit(ViewStore(entryStore).entry))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
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
                            entries: Logbook.Section.Entry.samples,
                            gradeSystems: [.mandala]
                        ),
                        reducer: DashboardSection()
                    )
                )
            }
        }
    }
}
