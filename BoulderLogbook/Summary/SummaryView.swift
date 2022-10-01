//
//  SummaryView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct SummaryView: View {
    let store: Store<SummaryState, SummaryAction>
    
    var body: some View {
        summaryList(with: store)
            .navigationDestination(
                for: Store<EntryState, EntryAction>.self
            ) { detailStore in
                EntryView(store: detailStore)
            }
    }
}

extension SummaryView {
    @ViewBuilder func summaryList(with store: Store<SummaryState, SummaryAction>) -> some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    LineChartView(
                        store: Store(
                            initialState: ChartState(viewStore.entryStates),
                            reducer: chartReducer,
                            environment: .init()
                        )
                    )
                    .frame(height: 150)
                }
                ForEachStore(
                    store.scope(
                        state: \.sections,
                        action: SummaryAction.summarySectionAction(id:action:)
                    )
                ) { sectionStore in
                    SummarySectionView(store: sectionStore)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle("Summary")
        }
    }
}


struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SummaryView(
                store: Store(
                    initialState: SummaryState(LogbookData.sampleLogbook),
                    reducer: summaryReducer,
                    environment: SummaryEnvironment(
                        mainQueue: .main,
                        fetch: { return .none },
                        delete: { _ in return .none }
                    )
                )
            )
        }
    }
}
