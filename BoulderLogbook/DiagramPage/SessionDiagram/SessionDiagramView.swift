//
//  SessionDiagramView.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.02.23.
//

import SwiftUI
import Charts
import ComposableArchitecture

struct SessionDiagramView: View {
    let store: StoreOf<SessionDiagram>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Chart(viewStore.months) { session in
                BarMark(
                    x: .value("Month", session.date),
                    y: .value("Tops", session.count)
                )
                .foregroundStyle(by: .value("Month", session.date))
                .annotation(position: .overlay, alignment: .bottom) {
                    if session.count > 0 {
                        Text("\(session.count)")
                            .foregroundColor(.white)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                }
            }
            .chartXAxisLabel(position: .top, content: {
                Text("Sessions per Month")
            })
            .chartLegend(.hidden)
            .padding(.top, 4)
        }
    }
}

struct SessionDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SessionDiagramView(
                store: Store(
                    initialState: SessionDiagram.State(
                        entries: Logbook.Section.Entry.samples
                    ),
                    reducer: SessionDiagram()
                )
            )
        }
    }
}
