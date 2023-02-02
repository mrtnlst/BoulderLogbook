//
//  DiagramView.swift
//  BoulderLogbook
//
//  Created by Martin List on 20.09.22.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct DiagramView: View {
    let store: StoreOf<Diagram>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if viewStore.filters.isEmpty {
                HStack {
                    Spacer()
                    Text("Long press to enable filters!")
                    Image(systemName: "hand.tap.fill")
                    Spacer()
                }
            } else {
                lineChartView()
                    .frame(height: 150)
            }
        }
    }
}

extension DiagramView {
    @ViewBuilder func lineChartView() -> some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Picker(
                        "Pick the number of sessions displayed in the chart!",
                        selection: viewStore.binding(
                            get: \.selectedSegment,
                            send: Diagram.Action.didSelectSegment)
                    ) {
                        ForEach(viewStore.availableSegments, id: \.self) { segment in
                            Text(segment.rawValue).tag(segment.tag)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Chart(viewStore.chartSections) { section in
                    LineMark(
                        x: .value("Date", section.date),
                        y: .value("Tops", section.count)
                    )
                    .foregroundStyle(by: .value("Grade", section.grade.gradeDescription))
                    .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    .symbol(Circle())
                }
                .chartXScale(domain: .automatic(reversed: true))
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(centered: false) {
                            if viewStore.hasXAxisValueLabel,
                               let date = value.as(String.self) {
                                Text(date)
                            }
                        }
                    }
                }
                .chartYScale(domain: 0...viewStore.maximumValue)
                .chartForegroundStyleScale(LegacyBoulderGrade.chartForegroundStyleScale)
                .chartLegend(.hidden)
//               FIXME: .animation(.default, value: viewStore.selectedSegment)
            }
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        DiagramView(
            store: Store(
                initialState: Diagram.State(
                    entries: Logbook.Section.Entry.samples
                ),
                reducer: Diagram()
            )
        )
        .frame(height: 200)
        .padding()
    }
}
