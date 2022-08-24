//
//  SummarySectionView.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import SwiftUI
import ComposableArchitecture

struct SummarySectionView: View {
    let store: Store<SummarySectionState, SummarySectionAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Section {
                ForEachStore(
                    store.scope(
                        state: \.entryStates,
                        action: SummarySectionAction.entryAction(id:action:))
                ) { entryStore in
                    summaryEntryView(for: entryStore)
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
                Text(viewStore.date, format: .dateTime.year().month(.wide))
            }
            .headerProminence(.increased)
        }
    }
}

extension SummarySectionView {
    @ViewBuilder func summaryEntryView(for entryStore: Store<EntryState, EntryAction>) -> some View {
        if #available(iOS 16, *) {
#if canImport(Charts)
            NavigationLink(value: entryStore) {
                SummaryEntryView(entry: ViewStore(entryStore).entry)
            }
#endif
        } else {
            ZStack {
                NavigationLink(destination: EntryView(store: entryStore)) {
                   EmptyView()
                }
                .opacity(0)
                SummaryEntryView(entry: ViewStore(entryStore).entry)
            }
        }
    }
}

struct SummarySectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SummarySectionView(
                store: Store(
                    initialState: SummarySectionState(
                        LogbookData.Section.sampleSections[0]
                    ),
                    reducer: summarySectionReducer,
                    environment: SummarySectionEnvironment()
                )
            )
        }
    }
}
