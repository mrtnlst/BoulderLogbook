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
#if canImport(Charts)
        if #available(iOS 16, *) {
            summaryList(with: store)
                .navigationDestination(
                    for: Store<SummaryDetailState, SummaryDetailAction>.self
                ) { detailStore in
                    SummaryDetailView(store: detailStore)
                }
        }
#else
        summaryList(with: store)
#endif
    }
}

extension SummaryView {
    @ViewBuilder func summaryList(with store: Store<SummaryState, SummaryAction>) -> some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    if !viewStore.logbook.logbookEntries.isEmpty {
                        BarChartView(
                            store: Store(
                                initialState: ChartState(logbook: viewStore.logbook),
                                reducer: chartReducer,
                                environment: .init()
                            )
                        )
                        .padding(.vertical, 8)
                    }
                }
                ForEachStore(
                    store.scope(
                        state: \.summarySections,
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
#if canImport(Charts)
        if #available(iOS 16.0, *) {
            NavigationStack {
                SummaryView(
                    store: Store(
                        initialState: SummaryState(
                            summarySections: .init(
                                uniqueElements: [
                                    .init(
                                        date: .now,
                                        summaryDetails: [
                                            .init(logbookEntry: exampleLogbook.logbookEntries[0]),
                                            .init(logbookEntry: exampleLogbook.logbookEntries[2])
                                        ]
                                    )
                                ]
                            )
                        ),
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
#else
        NavigationView {
            SummaryView(
                store: Store(
                    initialState: SummaryState(
                        summarySections: .init(
                            uniqueElements: [
                                .init(
                                    date: .now,
                                    summaryDetails: [
                                        .init(logbookEntry: exampleLogbook.logbookEntries[0]),
                                        .init(logbookEntry: exampleLogbook.logbookEntries[2])
                                    ]
                                )
                            ]
                        )
                    ),
                    reducer: summaryReducer,
                    environment: SummaryEnvironment(
                        mainQueue: .main,
                        fetch: { return .none },
                        delete: { _ in return .none }
                    )
                )
            )
        }
#endif
    }
}
