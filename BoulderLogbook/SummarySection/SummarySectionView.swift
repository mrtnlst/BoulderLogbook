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
                        state: \.summaryDetails,
                        action: SummarySectionAction.summaryDetailAction(id:action:))
                ) { detailStore in
                    
#if canImport(Charts)
                    if #available(iOS 16, *) {
                        NavigationLink(value: detailStore) {
                            SummaryEntryView(entry: ViewStore(detailStore).logbookEntry)
                        }
                    }
#else
                    SummaryEntryView(entry: ViewStore(detailStore).logbookEntry)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewStore.send(.delete(ViewStore(detailStore).logbookEntry))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                viewStore.send(.edit(ViewStore(detailStore).logbookEntry))
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
#endif
                }
            } header: {
                Text(viewStore.date, format: .dateTime.year().month(.wide))
            }
            .headerProminence(.increased)
        }
    }
}

struct SummarySectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SummarySectionView(
                store: Store(
                    initialState: .init(
                        date: .now,
                        summaryDetails: [
                            .init(logbookEntry: exampleLogbook.logbookEntries[0]),
                            .init(logbookEntry: exampleLogbook.logbookEntries[2])
                        ]
                    ),
                    reducer: summarySectionReducer,
                    environment: SummarySectionEnvironment()
                )
            )
        }
    }
}
