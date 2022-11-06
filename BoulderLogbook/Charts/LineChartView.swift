//
//  LineChartView.swift
//  BoulderLogbook
//
//  Created by Martin List on 20.09.22.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct LineChartView: View {
    let store: Store<ChartState, ChartAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.hasPicker {
                    Picker(
                        "Pick the number of sessions displayed in the chart!",
                        selection: viewStore.binding(
                            get: \.selectedSegment,
                            send: ChartAction.didSelectSegment)
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
                .chartForegroundStyleScale(BoulderGrade.chartForegroundStyleScale)
                .chartLegend(.hidden)
                .onLongPressGesture(
                    minimumDuration: 0.2,
                    perform: {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        viewStore.send(.presentSummaryChartFilter)
                    }
                )
//               FIXME: .animation(.default, value: viewStore.selectedSegment) 
            }
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(
            store: Store(
                initialState: ChartState(entries: LogbookData.Entry.sampleEntries),
                reducer: chartReducer,
                environment: ChartEnvironment()
            )
        )
        .frame(height: 200)
        .padding()
    }
}
