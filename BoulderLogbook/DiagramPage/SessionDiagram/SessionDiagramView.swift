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
    @ScaledMetric var size: CGFloat = 1
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            switch viewStore.viewState {
            case .loading:
                LoadingIndicator()
                    .frame(maxWidth: .infinity)

            case let .idle(models):
                barChart(models: models)

            case let .error(message):
                EmptyMessageView(message: message)
                    .frame(maxWidth: .infinity)
            }
        }
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

struct SessionDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        PlainList {
            PlainSection("Loading") {
                SessionDiagramView(
                    store: Store(
                        initialState: SessionDiagram.State()
                    ) {
                        SessionDiagram()
                    }
                )
                .frame(height: 200)
            }
            PlainSection("Diagram") {
                SessionDiagramView(
                    store: Store(
                        initialState: SessionDiagram.State(
                            viewState: .idle([
                                .init(date: "Apr", count: 12),
                                .init(date: "May", count: 1),
                                .init(date: "Jun", count: 6),
                                .init(date: "Jul", count: 10)
                            ])
                        )
                    ) {
                        SessionDiagram()
                    }
                )
                .frame(height: 200)
            }
            PlainSection("Empty") {
                SessionDiagramView(
                    store: Store(
                        initialState: SessionDiagram.State(
                            viewState: .error("No sessions available!")
                        )
                    ) {
                        SessionDiagram()
                    }
                )
                .frame(height: 200)
            }
        }
    }
}
