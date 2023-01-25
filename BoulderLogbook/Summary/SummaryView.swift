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
                if viewStore.entryStates.count > 2 {
                    summaryChart()
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
    
    @ViewBuilder func summaryChart() -> some View {
        Section {
            WithViewStore(store) { viewStore in
                LineChartView(
                    store: store.scope(
                        state: \.chartState,
                        action: SummaryAction.chart
                    )
                )
                .onLongPressGesture(
                    minimumDuration: 0.2,
                    perform: {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        viewStore.send(.presentSummaryChartFilter)
                    }
                )
            }
        }
    }
}


struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SummaryView(
                store: Store(
                    initialState: SummaryState(Logbook.sampleLogbook),
                    reducer: summaryReducer,
                    environment: SummaryEnvironment(
                        mainQueue: .main,
                        fetch: { return .none },
                        delete: { _ in return .none },
                        fetchFilters: { return .none }
                    )
                )
            )
        }
    }
}
