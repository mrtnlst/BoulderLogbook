//
//  DiagramPageView.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.02.23.
//

import SwiftUI
import ComposableArchitecture

struct DiagramPageView: View {
    let store: StoreOf<DiagramPage>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            TabView {
                IfLetStore(
                    store.scope(
                        state: \.topCountDiagram,
                        action: DiagramPage.Action.topCountDiagram
                    )
                ) { topCountDiagramStore in
                    TopCountDiagramView(
                        store: topCountDiagramStore,
                        onLongPressGesture: { viewStore.send(.setIsPresentingFilter(true)) }
                    )
                }
                if viewStore.topCountDiagram == nil {
                    emptyDataView()
                }
            }
            .onAppear { viewStore.send(.fetchSelectedSystem) }
            .frame(height: 150)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresentingFilter,
                    send: DiagramPage.Action.setIsPresentingFilter
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.filterSheet,
                        action: DiagramPage.Action.filterSheet
                    )
                ) { filterSheetStore in
                    FilterSheetView(store: filterSheetStore)
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

extension DiagramPageView {
    @ViewBuilder func emptyDataView() -> some View {
        WithViewStore(store, observe: { $0.entries}) { viewStore in
            HStack {
                Spacer()
                Image(systemName: "hand.tap.fill")
                Text("Long press to configure diagrams!")
                Spacer()
            }
            .font(.subheadline)
            .onLongPressGesture(minimumDuration: 0.2) {
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
                viewStore.send(.setIsPresentingFilter(true))
            }
        }
    }
}

struct DiagramPageView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DiagramPageView(
                store: Store(
                    initialState: DiagramPage.State(
                        entries: Logbook.Section.Entry.samples,
                        gradeSystems: [.mandala]
                    ),
                    reducer: DiagramPage()
                )
            )
            DiagramPageView(
                store: Store(
                    initialState: DiagramPage.State(
                        entries: [],
                        gradeSystems: []
                    ),
                    reducer: DiagramPage()
                )
            )
        }
    }
}
