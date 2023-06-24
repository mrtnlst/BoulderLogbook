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
                picker()
                    .padding(.bottom, 8)
                ZStack {
                    let tops = viewStore.tops
                    let grades = viewStore.gradeSystem?.grades ?? []
                    
                    if grades.isEmpty {
                        Text("Choose grade system in Settings.")
                            .font(.footnote)
                            .fontWeight(.medium)
                    } else if tops.isEmpty {
                        Text("No entries are available.")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                    chart(
                        grades: grades.isEmpty ? GradeSystem.mandala.grades : grades,
                        tops: tops
                    )
                    .opacity(tops.isEmpty ? 0.5 : 1.0)
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
    
    @ViewBuilder func chart(grades: [GradeSystem.Grade], tops: [Top]) -> some View {
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
    }
}

struct TopCountDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TopCountDiagramView(
                store: Store(
                    initialState: TopCountDiagram.State(
                        entries: .samples,
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
            TopCountDiagramView(
                store: Store(
                    initialState: TopCountDiagram.State(
                        gradeSystem: GradeSystem.mandala
                    ),
                    reducer: TopCountDiagram()
                )
            )
                .frame(height: 170)
        }
    }
}
