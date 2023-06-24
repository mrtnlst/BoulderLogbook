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
            ZStack {
                if viewStore.entries.isEmpty {
                    Text("No entries are available.")
                        .font(.footnote)
                        .fontWeight(.medium)
                }
                barChart(months: viewStore.months)
            }
        }
    }
}

extension SessionDiagramView {
    @ViewBuilder func barChart(months: [SessionDiagram.Month]) -> some View {
        Chart(months) { session in
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
        .chartXAxisLabel(position: .top) {
            Text("Sessions per Month")
        }
        .chartLegend(.hidden)
        .padding(.top, 4)
    }
}

struct SessionDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SessionDiagramView(
                store: Store(
                    initialState: SessionDiagram.State(
                        entries: .samples
                    ),
                    reducer: SessionDiagram()
                )
            )
            SessionDiagramView(
                store: Store(
                    initialState: SessionDiagram.State(
                        entries: []
                    ),
                    reducer: SessionDiagram()
                )
            )
        }
    }
}
