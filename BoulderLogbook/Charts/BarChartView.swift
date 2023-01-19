//
//  BarChartView.swift
//  BoulderLogbook
//
//  Created by Martin List on 19.07.22.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct BarChartView: View {
    let store: Store<ChartState, ChartAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
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
                Chart(viewStore.chartSections) { section in
                    BarMark(
                        x: .value("Date", section.date),
                        y: .value("Total Tops", section.count)
                    )
                    .foregroundStyle(by: .value("Grade", section.grade.gradeDescription))
                }
                .chartXScale(domain: .automatic(reversed: true))
                .chartForegroundStyleScale(BoulderGrade.chartForegroundStyleScale)
                .chartLegend(.hidden)
                .frame(height: 200)
                .animation(.default, value: viewStore.selectedSegment)
            }
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(
            store: Store(
                initialState: ChartState(entries: Logbook.Entry.sampleEntries),
                reducer: chartReducer,
                environment: ChartEnvironment()
            )
        )
        .padding()
    }
}
