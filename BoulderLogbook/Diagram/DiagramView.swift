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
//            if viewStore.filters.isEmpty {
//                HStack {
//                    Spacer()
//                    Text("Long press to enable filters!")
//                    Image(systemName: "hand.tap.fill")
//                    Spacer()
//                }
//            } else {
            if viewStore.entries.count < 3 {
                emptyDataView(count: viewStore.entries.count)
            } else {
                lineChartView()
                .onAppear { viewStore.send(.onAppear) }
                .frame(height: 150)
            }
        }
    }
}

extension DiagramView {
    @ViewBuilder func lineChartView() -> some View {
        WithViewStore(store) { viewStore in
            VStack {
                if !viewStore.availableSegments.isEmpty {
                    Picker(
                        "Pick the number of sessions displayed in the chart!",
                        selection: viewStore.binding(\.$selectedSegment)
                    ) {
                        ForEach(viewStore.availableSegments, id: \.self) { segment in
                            Text(segment.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 4)
                }
                let entries = viewStore.chartEntries
                Chart(entries) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Tops", entry.count)
                    )
                    .foregroundStyle(by: .value("Grade", entry.grade.name))
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
                .chartForegroundStyleScale(
                    range: lineMarkColors(
                        entries: entries,
                        limit: viewStore.selectedSystem?.grades.count ?? 0
                    )
                )
                .chartLegend(.hidden)
                .onLongPressGesture(
                    minimumDuration: 0.2,
                    perform: {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        viewStore.send(.presentFilters)
                    }
                )
//               FIXME: .animation(.default, value: viewStore.selectedSegment)
            }
        }
    }
    
    @ViewBuilder func emptyDataView(count: Int) -> some View {
        HStack {
            Spacer()
            Image(systemName: "chart.xyaxis.line")
            Text("Add \(3 - count) more entries for a fancy diagram!")
            Spacer()
        }
        .font(.footnote)
        .foregroundColor(.primary)
    }
    
    func lineMarkColors(
        entries: [Diagram.State.Entry],
        limit: Int
    ) -> [Color] {
        var returnColors: [GradeSystem.Grade] = []
        entries.forEach { entry in
            guard returnColors.count < limit else {
                return
            }
            if !returnColors.contains(entry.grade) {
                returnColors.append(entry.grade)
            }
        }
        return returnColors.map { $0.color }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DiagramView(
                store: Store(
                    initialState: Diagram.State(
                        entries: [Logbook.Section.Entry.samples[0]]
                    ),
                    reducer: Diagram()
                        .dependency(\.gradeSystemClient, .previewValue)
                )
            )
            DiagramView(
                store: Store(
                    initialState: Diagram.State(
                        entries: Logbook.Section.Entry.samples + Logbook.Section.Entry.samples,
                        gradeSystems: [.mandala],
                        filters: Filter.samples.dropLast(4)
                    ),
                    reducer: Diagram()
                        .dependency(\.gradeSystemClient, .previewValue)
                )
            )
            .frame(height: 200)
        }
    }
}
