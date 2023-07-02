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
            TabView(selection: viewStore.binding(\.$selectedTab)) {
                TopCountDiagramView(
                    store: store.scope(
                        state: \.topCountDiagram,
                        action: DiagramPage.Action.topCountDiagram
                    )
                )
                .tag(0)
                SessionDiagramView(
                    store: store.scope(
                        state: \.sessionDiagram,
                        action: DiagramPage.Action.sessionDiagram
                    )
                )
                .tag(1)
                SummaryDiagramView(
                    store: store.scope(
                        state: \.summaryDiagram,
                        action: DiagramPage.Action.summaryDiagram
                    )
                )
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onAppear { viewStore.send(.onAppear) }
        }
        .frame(height: 200)
    }
}

struct DiagramPageView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DiagramPageView(
                store: Store(
                    initialState: DiagramPage.State(),
                    reducer: DiagramPage()
                )
            )
        }
    }
}
