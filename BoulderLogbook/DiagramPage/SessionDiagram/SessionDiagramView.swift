//
//  SessionDiagramView.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.02.23.
//

import SwiftUI
import Charts
import ComposableArchitecture

@ViewAction(for: SessionDiagram.self)
struct SessionDiagramView: View {
    let store: StoreOf<SessionDiagram>

    var body: some View {
        PlainList {
            switch store.viewState {
            case .loading:
                LoadingIndicator()
                    .frame(maxWidth: .infinity)
                
            case let .idle(models):
                barChart(models: models)
                    .frame(height: 300)
                
            case let .error(message):
                EmptyMessageView(message: message)
                    .frame(maxWidth: .infinity)
            }
        }
        .task { send(.task) }
        .navigationTitle("Details")
    }
}

extension SessionDiagramView {
    func barChart(models: [SessionDiagram.Model]) -> some View {
        Chart(models) { model in
            BarMark(
                x: .value("Month", model.date),
                y: .value("Tops", model.count)
            )
            .foregroundStyle(by: .value("Month", model.date))
            .annotation(position: .overlay, alignment: .bottom) {
                Text("\(model.count)")
                    .foregroundStyle(.primaryText)
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
        }
        .chartForegroundStyleScale(range: [Color.accentColor])
        .chartXAxisLabel(position: .top) {
            Text("Sessions per Month")
                .foregroundStyle(.primaryText)
        }
        .chartXAxis {
            AxisMarks(values: .automatic) {
                AxisValueLabel()
                    .foregroundStyle(.primaryText)
                AxisGridLine()
                    .foregroundStyle(.primaryText.opacity(0.4))
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) {
                AxisValueLabel()
                    .foregroundStyle(.primaryText)
                AxisGridLine()
                    .foregroundStyle(.primaryText.opacity(0.4))
            }
        }
        .chartLegend(.hidden)
        .padding(.top, 4)
    }
}

#Preview {
    SessionDiagramView(
        store: Store(
            initialState: SessionDiagram.State(
                sections: Shared(
                    value: Logbook.sample2.sections
                )
            )
        ) {
            SessionDiagram()
        }
    )
}
