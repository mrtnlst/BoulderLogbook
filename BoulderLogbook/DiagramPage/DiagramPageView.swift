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
            }
            .frame(height: 170)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

extension DiagramPageView {
    @ViewBuilder func emptyDataView() -> some View {
        WithViewStore(store, observe: { $0.entries}) { viewStore in
            HStack {
                Spacer()
                Button {
                    viewStore.send(.presentFilters)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .fontWeight(.bold)
                Text("Tap filter button to configure diagrams!")
                Spacer()
            }
            .font(.subheadline)
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
