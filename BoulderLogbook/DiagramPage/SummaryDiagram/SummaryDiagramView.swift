//
//  SummaryDiagramView.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.06.23.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct SummaryDiagramView: View {
    let store: StoreOf<SummaryDiagram>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                let sections = viewStore.sections
                let grades = viewStore.gradeSystem?.grades ?? []
               
                if grades.isEmpty {
                    Text("Choose grade system in Settings.")
                        .font(.footnote)
                        .fontWeight(.medium)
                } else if sections.isEmpty {
                    Text("No entries are available.")
                        .font(.footnote)
                        .fontWeight(.medium)
                }
                barChart(
                    with: sections,
                    grades: grades.isEmpty ? GradeSystem.mandala.grades : grades
                )
                .opacity(sections.isEmpty ? 0.5 : 1.0)
            }
        }
    }
}

private extension SummaryDiagramView {
    @ViewBuilder func barChart(
        with sections: [SummaryDiagram.BarMarkSection],
        grades: [GradeSystem.Grade]
    ) -> some View {
        Chart(sections) { section in
            if section.tops > 0 {
                barMark(value: section.tops, grade: section.grade, image: "triangle.fill")
            }
            if section.attempts > 0 {
                barMark(value: section.attempts, grade: section.grade, image: "figure.fall")
                    .opacity(0.8)
            }
            if section.flash > 0 {
                barMark(value: section.flash, grade: section.grade, image: "bolt.fill")
                    .opacity(0.6)
            }
            if section.onsight > 0 {
                barMark(value: section.onsight, grade: section.grade, image: "eye.fill")
                    .opacity(0.4)
            }
        }
        .chartYScale(domain: [0, (sections.map { $0.maxValue }.max() ?? 0) + 3])
        .chartForegroundStyleScale(range: GradeSystem.mandala.grades.map { $0.color })
        .chartLegend(.hidden)
        .chartXAxisLabel(position: .top) {
            Text("Summary of the last 7 days")
        }
        .padding(.top, 4)
    }
    
    @ChartContentBuilder func barMark(
        value: Int,
        grade: GradeSystem.Grade,
        image: String
    ) -> some ChartContent {
        BarMark(
            x: .value("Grade", grade.name),
            y: .value("Top", value)
        )
        .foregroundStyle(by: .value("Grade", grade.name))
        .annotation(position: .overlay, alignment: .bottom) {
            HStack(spacing: 0) {
                Image(systemName: image)
                Text("\(value)")
            }
            .foregroundColor(grade.color.isBright ? .black : .white)
            .font(.caption)
        }
    }
}

struct SummaryDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SummaryDiagramView(
                store: Store(
                    initialState: .init(
                        entries: .samples,
                        gradeSystem: .mandala
                    ),
                    reducer: SummaryDiagram()
                )
            )
            .frame(height: 200)
            SummaryDiagramView(
                store: Store(
                    initialState: .init(
                        entries: [],
                        gradeSystem: .mandala
                    ),
                    reducer: SummaryDiagram()
                )
            )
            .frame(height: 200)
            SummaryDiagramView(
                store: Store(
                    initialState: .init(
                        entries: [],
                        gradeSystem: nil
                    ),
                    reducer: SummaryDiagram()
                )
            )
            .frame(height: 200)
        }
    }
}
