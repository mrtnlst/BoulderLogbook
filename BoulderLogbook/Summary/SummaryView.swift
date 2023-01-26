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
                for: StoreOf<EntryDetail>.self
            ) { detailStore in
                EntryDetailView(store: detailStore)
            }
    }
}

extension SummaryView {
    @ViewBuilder func summaryList(with store: Store<SummaryState, SummaryAction>) -> some View {
        WithViewStore(store) { viewStore in
            List {
                if viewStore.entryStates.count > 2 {
                    diagramView()
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
    
    @ViewBuilder func diagramView() -> some View {
        Section {
            WithViewStore(store) { viewStore in
                DiagramView(
                    store: store.scope(
                        state: \.diagramState,
                        action: SummaryAction.diagram
                    )
                )
                .onLongPressGesture(
                    minimumDuration: 0.2,
                    perform: {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        viewStore.send(.presentFilters)
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
