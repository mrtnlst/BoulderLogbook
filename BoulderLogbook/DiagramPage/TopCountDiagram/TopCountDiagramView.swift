//
//  TopCountDiagramView.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.02.23.
//

import SwiftUI
import Charts
import ComposableArchitecture

struct TopCountDiagramView: View {
    @Bindable var store: StoreOf<TopCountDiagram>

    var body: some View {
        switch store.viewState {
        case .loading:
            LoadingIndicator()
                .frame(maxWidth: .infinity)

        case let .idle(tops):
            VStack {
                picker()
                    .padding(.bottom, 4)
                barChart(
                    grades: store.gradeSystem?.grades ?? [],
                    tops: tops
                )
            }

        case let .error(message):
            EmptyMessageView(message: message) {
                store.send(.didPressEmptyView)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

extension TopCountDiagramView {
    @MainActor
    func picker() -> some View {
        PlainPicker(
            title: "Pick the number of sessions displayed in the chart!",
            selection: $store.selectedSegment
        ) {
            ForEach(TopCountDiagram.Segment.allCases, id: \.self) { segment in
                Text(segment.rawValue)
            }
        }
        .disabled($store.gradeSystem.wrappedValue == nil ? true : false)
    }
    
    @ViewBuilder func barChart(grades: [Grade], tops: [Top]) -> some View {
        Chart(grades) { grade in
            BarMark(
                x: .value("Grade", grade.name),
                y: .value("Tops", tops.count(for: grade))
            )
            .foregroundStyle(by: .value("Grade", grade.name))
            .annotation(position: .top, alignment: .bottom) {
                if tops.count > 0 {
                    Text("\(tops.count(for: grade))")
                        .foregroundStyle(.primaryText)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
            }
        }
        .chartForegroundStyleScale(range: grades.map { $0.color })
        .chartLegend(.hidden)
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
    }
}

#Preview {
    PlainList {
        PlainSection("Loading") {
            TopCountDiagramView(
                store: Store(
                    initialState: TopCountDiagram.State(
                    )
                ) {
                    TopCountDiagram()
                }
            )
            .frame(height: 170)
        }
        PlainSection("Diagram") {
            TopCountDiagramView(
                store: Store(
                    initialState: TopCountDiagram.State(
                        viewState: .idle([
                            .sample1,
                            .sample1,
                            .sample5,
                            .sample6
                        ]),
                        gradeSystem: .mandala
                    )
                ) {
                    TopCountDiagram()
                }
            )
            .frame(height: 170)
        }
        PlainSection("Empty") {
            TopCountDiagramView(
                store: Store(
                    initialState: TopCountDiagram.State(
                        viewState: .error("No entries available!")
                    )
                ) {
                    TopCountDiagram()
                }
            )
            .frame(height: 170)
        }
    }
}
