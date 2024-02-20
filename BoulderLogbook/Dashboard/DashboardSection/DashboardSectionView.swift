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
        WithViewStore(store, observe: { $0 }) { viewStore in
            PlainSection {
                ForEach(viewStore.entryDetailStates) { entryDetailState in
                    Button {
                        viewStore.send(.setNavigation(entryDetailState.id))
                    } label: {
                        DashboardEntryView(
                            entry: entryDetailState.entry,
                            gradeSystem: entryDetailState.gradeSystem
                        )
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewStore.send(.delete(entryDetailState.id))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.araError)
                        Button {
                            viewStore.send(.edit(entryDetailState.entry))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.araWarning)
                    }
                }
            } header: {
                Text(
                    viewStore.date,
                    format: .dateTime.year().month(.wide)
                )
                .font(.title3)
                .fontWeight(.semibold)
            }
        }
        .navigationDestination(
            store: store.scope(state: \.$entryDetail, action: \.entryDetail)
        ) {
            EntryDetailView(store: $0)
        }
    }
}

struct DashboardSectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PlainList {
                DashboardSectionView(
                    store: Store(
                        initialState: DashboardSection.State(
                            date: .now,
                            entries: .samples,
                            gradeSystems: [.mandala]
                        )
                    ) {
                        DashboardSection()
                    }
                )
            }
        }
    }
}
