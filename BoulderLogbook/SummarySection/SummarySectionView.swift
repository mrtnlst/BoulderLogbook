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
                ) { detailStore in
#if canImport(Charts)
                    if #available(iOS 16, *) {
                        NavigationLink(value: detailStore) {
                            SummaryEntryView(entry: ViewStore(detailStore).entry)
                        }
                    }
#else
                    SummaryEntryView(entry: ViewStore(detailStore).entry)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewStore.send(.delete(ViewStore(detailStore).entry))
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                viewStore.send(.edit(ViewStore(detailStore).entry))
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
