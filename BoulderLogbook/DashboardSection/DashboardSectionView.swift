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
                        DashboardEntryView(entry: ViewStore(entryStore).entry)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewStore.send(.delete(ViewStore(entryStore).entry))
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

struct SummarySectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                DashboardSectionView(
                    store: Store(
                        initialState: DashboardSection.State(
                            Logbook.Section.sampleSections[0]
                        ),
                        reducer: DashboardSection()
                    )
                )
            }
        }
    }
}
