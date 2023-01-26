//
//  SummarySectionView.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import SwiftUI
import ComposableArchitecture

struct SummarySectionView: View {
    let store: StoreOf<SummarySection>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Section {
                ForEachStore(
                    store.scope(
                        state: \.entryStates,
                        action: SummarySection.Action.entryAction(id:action:))
                ) { entryStore in
                    NavigationLink(value: entryStore) {
                        SummaryEntryView(entry: ViewStore(entryStore).entry)
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
                SummarySectionView(
                    store: Store(
                        initialState: SummarySection.State(
                            Logbook.Section.sampleSections[0]
                        ),
                        reducer: SummarySection()
                    )
                )
            }
        }
    }
}
