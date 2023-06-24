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
                TopCountDiagramView(
                    store: store.scope(
                        state: \.topCountDiagram,
                        action: DiagramPage.Action.topCountDiagram
                    )
                )
                SessionDiagramView(
                    store: store.scope(
                        state: \.sessionDiagram,
                        action: DiagramPage.Action.sessionDiagram
                    )
                )
                SummaryDiagramView(
                    store: store.scope(
                        state: \.summaryDiagram,
                        action: DiagramPage.Action.summaryDiagram
                    )
                )
            }
            .frame(height: 200)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct DiagramPageView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DiagramPageView(
                store: Store(
                    initialState: DiagramPage.State(
                        entries: .samples,
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
