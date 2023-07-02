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
            switch viewStore.viewState {
            case .loading:
                LoadingIndicator()
                    .frame(maxWidth: .infinity)
                
            case let .idle(models):
                barChart(
                    models: models,
                    hasWeekFilter: viewStore.hasWeekFilter
                )

            case let .empty(message):
                EmptyMessageView(message: message)
                    .frame(maxWidth: .infinity)
            }
//            ZStack {
//                let models = viewStore.models
//                let grades = viewStore.gradeSystem?.grades ?? []
//
//                if grades.isEmpty {
//                    Text("Choose grade system in Settings.")
//                        .font(.footnote)
//                        .fontWeight(.medium)
//                } else if models.isEmpty {
//                    Text("No entries are available.")
//                        .font(.footnote)
//                        .fontWeight(.medium)
//                }
//                barChart(
//                    with: models,
//                    grades: grades.isEmpty ? GradeSystem.mandala.grades : grades,
//                    hasWeekFilter: viewStore.hasWeekFilter
//                )
//                .opacity(models.isEmpty ? 0.5 : 1.0)
//            }
        }
    }
}

private extension SummaryDiagramView {
    @ViewBuilder func barChart(
        models: [SummaryDiagram.Model],
        hasWeekFilter: Bool
    ) -> some View {
        let grades = models.first?.gradeSystem.grades ?? []
        Chart(models) { section in
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
        .chartYScale(domain: [0, (models.map { $0.maxValue }.max() ?? 0) + 1])
        .chartForegroundStyleScale(range: grades.map { $0.color })
        .chartLegend(.hidden)
        .chartXAxisLabel(position: .top) {
            if hasWeekFilter {
                Text("Summary of the last 7 days")
            }
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
            Section {
                SummaryDiagramView(
                    store: Store(
                        initialState: .init(hasWeekFilter: true),
                        reducer: SummaryDiagram()
                    )
                )
                .frame(height: 170)
            }
            Section {
                SummaryDiagramView(
                    store: Store(
                        initialState: SummaryDiagram.State(
                            hasWeekFilter: true,
                            viewState: .idle([
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: GradeSystem.Grade.mandalaBlue,
                                    tops: 3,
                                    attempts: 0,
                                    flash: 0,
                                    onsight: 0
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: GradeSystem.Grade.mandalaRed,
                                    tops: 3,
                                    attempts: 0,
                                    flash: 2,
                                    onsight: 2
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: GradeSystem.Grade.mandalaOrange,
                                    tops: 0,
                                    attempts: 0,
                                    flash: 1,
                                    onsight: 2
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: GradeSystem.Grade.mandalaBlack,
                                    tops: 2,
                                    attempts: 1,
                                    flash: 0,
                                    onsight: 0
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: GradeSystem.Grade.mandalaWhite,
                                    tops: 1,
                                    attempts: 3,
                                    flash: 0,
                                    onsight: 0
                                )
                            ])
                        ),
                        reducer: SummaryDiagram())
                )
                .frame(height: 200)
            }
            Section {
                SummaryDiagramView(
                    store: Store(
                        initialState: .init(
                            hasWeekFilter: true,
                            viewState: .empty("No entries available!")
                        ),
                        reducer: SummaryDiagram()
                    )
                )
                .frame(height: 170)
            }
        }
    }
}
