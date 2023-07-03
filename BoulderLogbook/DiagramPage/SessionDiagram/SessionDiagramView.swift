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
        WithViewStore(store) { viewStore in
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
                    .foregroundColor(.white)
                    .font(.caption2)
                    .fontWeight(.semibold)
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
            Section {
                SessionDiagramView(
                    store: Store(
                        initialState: SessionDiagram.State(),
                        reducer: SessionDiagram()
                    )
                )
                .frame(height: 200)
            }
            Section {
                SessionDiagramView(
                    store: Store(
                        initialState: SessionDiagram.State(
                            viewState: .idle([
                                .init(date: "Apr", count: 12),
                                .init(date: "May", count: 1),
                                .init(date: "Jun", count: 6),
                                .init(date: "Jul", count: 10)
                            ])
                        ),
                        reducer: SessionDiagram()
                    )
                )
                .frame(height: 200)
            }
            Section {
                SessionDiagramView(
                    store: Store(
                        initialState: SessionDiagram.State(
                            viewState: .error("No sessions available!")
                        ),
                        reducer: SessionDiagram()
                    )
                )
                .frame(height: 200)
            }
        }
    }
}
