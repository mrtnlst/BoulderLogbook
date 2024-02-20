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
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .center) {
                TabView(selection: viewStore.$selectedTab) {
                    TopCountDiagramView(
                        store: store.scope(
                            state: \.topCountDiagram,
                            action: \.topCountDiagram
                        )
                    )
                    .tag(DiagramPage.State.Tab.topCount)
                    SessionDiagramView(
                        store: store.scope(
                            state: \.sessionDiagram,
                            action: \.sessionDiagram
                        )
                    )
                    .tag(DiagramPage.State.Tab.session)
                    SummaryDiagramView(
                        store: store.scope(
                            state: \.summaryDiagram,
                            action: \.summaryDiagram
                        )
                    )
                    .tag(DiagramPage.State.Tab.summary)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear { viewStore.send(.onAppear) }
                .frame(height: 200)
                
                HStack {
                    ForEach(DiagramPage.State.Tab.allCases, id: \.rawValue) { tab in
                        Capsule()
                            .foregroundStyle(.primaryText)
                            .frame(
                                width: viewStore.selectedTab == tab ? 8 : 6,
                                height: viewStore.selectedTab == tab ? 8 : 6
                            )
                            .opacity(viewStore.selectedTab == tab ? 0.8 : 0.4)
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
    }
}

struct DiagramPageView_Previews: PreviewProvider {
    static var previews: some View {
        PlainList {
            DiagramPageView(
                store: Store(
                    initialState: DiagramPage.State()
                ) {
                    DiagramPage()
                }
            )
        }
    }
}
