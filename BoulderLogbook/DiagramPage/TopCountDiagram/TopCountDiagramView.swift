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
    let store: StoreOf<TopCountDiagram>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    picker()
                    filterButton()
                }
                .padding(.bottom, 8)
                if let gradeSystem = viewStore.gradeSystem {
                    chart(grades: gradeSystem.grades, tops: viewStore.tops)
                } else {
                    chart(grades: GradeSystem.mandala.grades, tops: [])
                }
            }
        }
    }
}

extension TopCountDiagramView {
    @ViewBuilder func picker() -> some View {
        WithViewStore(store) { viewStore in
            Picker(
                "Pick the number of sessions displayed in the chart!",
                selection: viewStore.binding(\.$selectedSegment)
            ) {
                ForEach(TopCountDiagram.Segment.allCases, id: \.self) { segment in
                    Text(segment.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .disabled(viewStore.tops.isEmpty ? true : false)
        }
    }
    
    @ViewBuilder func filterButton() -> some View {
        WithViewStore(store) { viewStore in
            Button {
                viewStore.send(.presentFilters)
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
            .fontWeight(.bold)
        }
    }
    
    @ViewBuilder func chart(grades: [GradeSystem.Grade], tops: [Top]) -> some View {
        ZStack {
            if tops.isEmpty {
                Text("Use filter button  to configure diagrams!")
                    .font(.footnote)
                    .fontWeight(.medium)
            }
            Chart(grades) { grade in
                BarMark(
                    x: .value("Grade", grade.name),
                    y: .value("Tops", tops.count(for: grade))
                )
                .foregroundStyle(by: .value("Grade", grade.name))
                .annotation(position: .top, alignment: .bottom) {
                    if tops.count > 0 {
                        Text("\(tops.count(for: grade))")
                            .foregroundColor(.secondary)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                }
            }
            .chartForegroundStyleScale(range: grades.map { $0.color })
            .chartLegend(.hidden)
            .opacity(tops.isEmpty ? 0.5 : 1.0)
        }
    }
}

struct TopCountDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TopCountDiagramView(
                store: Store(
                    initialState: TopCountDiagram.State(
                        entries: Logbook.Section.Entry.samples,
                        gradeSystem: .mandala
                    ),
                    reducer: TopCountDiagram()
                )
            )
                .frame(height: 170)
            TopCountDiagramView(
                store: Store(
                    initialState: TopCountDiagram.State(),
                    reducer: TopCountDiagram()
                )
            )
                .frame(height: 170)
        }
    }
}
