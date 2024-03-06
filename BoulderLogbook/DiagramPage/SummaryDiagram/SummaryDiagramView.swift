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
        WithViewStore(store, observe: { $0 }) { viewStore in
            switch viewStore.viewState {
            case .loading:
                LoadingIndicator()
                    .frame(maxWidth: .infinity)
                
            case let .idle(models):
                barChart(
                    models: models,
                    hasWeekFilter: viewStore.hasWeekFilter
                )

            case let .error(error):
                let action: () -> Void = { viewStore.send(.didPressEmptyView) }
                
                EmptyMessageView(
                    message: error?.text,
                    action: error == .noGradeSystem ? action : nil
                )
                .frame(maxWidth: .infinity)
            }
        }
    }
}

private extension SummaryDiagramView {
    @ViewBuilder func barChart(
        models: [SummaryDiagram.Model],
        hasWeekFilter: Bool
    ) -> some View {
        let grades = models.first?.gradeSystem.grades ?? []
        Chart(models) { model in
            if model.tops > 0 {
                barMark(value: model.tops, grade: model.grade, image: "triangle.fill")
            }
            if model.attempts > 0 {
                barMark(value: model.attempts, grade: model.grade, image: "figure.fall")
                    .opacity(0.8)
            }
            if model.flash > 0 {
                barMark(value: model.flash, grade: model.grade, image: "bolt.fill")
                    .opacity(0.6)
            }
            if model.onsight > 0 {
                barMark(value: model.onsight, grade: model.grade, image: "eye.fill")
                    .opacity(0.4)
            }
            // Show grades without tops. Fixes mapping of colors via `chartForegroundStyleScale`.
            BarMark(
                x: .value("Grade", model.grade.name),
                y: .value("Top", 0)
            )
            .foregroundStyle(by: .value("Grade", model.grade.name))
        }
        .chartYScale(domain: [0, (models.map { $0.maxValue }.max() ?? 0) + 1])
        .chartForegroundStyleScale(range: grades.map { $0.color })
        .chartLegend(.hidden)
        .chartXAxisLabel(position: .top) {
            if hasWeekFilter {
                Text("Summary of the last 7 days")
                    .foregroundStyle(.primaryText)
            }
        }
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
        .padding(.top, 4)
    }
    
    @ChartContentBuilder func barMark(
        value: Int,
        grade: Grade,
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
            .foregroundStyle(grade.color.isBright ? .primaryTextDark : .primaryText)
            .font(.caption)
        }
    }
}

struct SummaryDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        PlainList {
            PlainSection("Loading") {
                SummaryDiagramView(
                    store: Store(initialState: .init(hasWeekFilter: true)) {
                        SummaryDiagram()
                    }
                )
                .frame(height: 170)
            }
            PlainSection("Diagram") {
                SummaryDiagramView(
                    store: Store(
                        initialState: SummaryDiagram.State(
                            hasWeekFilter: true,
                            viewState: .idle([
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: Grade.mandalaBlue,
                                    tops: 3,
                                    attempts: 0,
                                    flash: 0,
                                    onsight: 0
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: Grade.mandalaRed,
                                    tops: 3,
                                    attempts: 0,
                                    flash: 2,
                                    onsight: 2
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: Grade.mandalaOrange,
                                    tops: 0,
                                    attempts: 0,
                                    flash: 1,
                                    onsight: 2
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: Grade.mandalaBlack,
                                    tops: 0,
                                    attempts: 0,
                                    flash: 0,
                                    onsight: 0
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: Grade.mandalaWhite,
                                    tops: 1,
                                    attempts: 3,
                                    flash: 0,
                                    onsight: 0
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: Grade.mandalaYellow,
                                    tops: 0,
                                    attempts: 0,
                                    flash: 0,
                                    onsight: 0
                                ),
                                SummaryDiagram.Model(
                                    gradeSystem: .mandala,
                                    grade: Grade.mandalaPurple,
                                    tops: 1,
                                    attempts: 4,
                                    flash: 3,
                                    onsight: 0
                                )
                            ])
                        )
                    ) {
                        SummaryDiagram()
                    }
                )
                .frame(height: 200)
            }
            PlainSection("Empty") {
                SummaryDiagramView(
                    store: Store(
                        initialState: .init(
                            hasWeekFilter: true,
                            viewState: .error(.noEntries)
                        )
                    ) {
                        SummaryDiagram()
                    }
                )
                .frame(height: 170)
            }
        }
    }
}
