//
//  BarChartView.swift
//  BoulderLogbook
//
//  Created by Martin List on 19.07.22.
//

import SwiftUI
import ComposableArchitecture
#if canImport(Charts)
import Charts
#endif

struct BarChartView: View {
    let store: Store<ChartState, ChartAction>
    
    var body: some View {
#if canImport(Charts)
        WithViewStore(store) { viewStore in
            VStack {
                Picker(
                    "Pick the number of sessions displayed in the chart!",
                    selection: viewStore.binding(
                        get: \.selectedSegment,
                        send: ChartAction.didSelectSegment)
                ) {
                    Text("Past 7").tag(ChartState.Segment.week)
                    Text("Past 30").tag(ChartState.Segment.month)
                    Text("All time").tag(ChartState.Segment.all)
                }
                .pickerStyle(.segmented)
                if #available(iOS 16.0, *) {
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
                    // TODO: Hide x-axis labels when selected segment != .week
                }
            }
        }
#else
        EmptyView()
#endif
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(
            store: Store(
                initialState: ChartState(entries: LogbookData.Entry.sampleEntries),
                reducer: chartReducer,
                environment: ChartEnvironment()
            )
        )
        .padding()
    }
}
