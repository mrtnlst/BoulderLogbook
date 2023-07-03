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
            switch viewStore.viewState {
            case .loading:
                LoadingIndicator()
                    .frame(maxWidth: .infinity)
                
            case let .idle(tops):
                VStack {
                    picker()
                        .padding(.bottom, 4)
                    barChart(
                        grades: viewStore.gradeSystem?.grades ?? [],
                        tops: tops
                    )
                }
                
            case let .error(message):
                EmptyMessageView(message: message)
                    .frame(maxWidth: .infinity)
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
            .disabled(viewStore.gradeSystem == nil ? true : false)
        }
    }
    
    @ViewBuilder func barChart(grades: [GradeSystem.Grade], tops: [Top]) -> some View {
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
            Section {
                TopCountDiagramView(
                    store: Store(
                        initialState: TopCountDiagram.State(
                        ),
                        reducer: TopCountDiagram()
                    )
                )
                .frame(height: 170)
            }
            Section {
                TopCountDiagramView(
                    store: Store(
                        initialState: TopCountDiagram.State(
                            viewState: .idle([
                                .sample1,
                                .sample1,
                                .sample5,
                                .sample6
                            ]),
                            gradeSystem: .mandala
                        ),
                        reducer: TopCountDiagram()
                    )
                )
                .frame(height: 170)
            }
            Section {
                TopCountDiagramView(
                    store: Store(
                        initialState: TopCountDiagram.State(
                            viewState: .error("No entries available!")
                        ),
                        reducer: TopCountDiagram()
                    )
                )
                .frame(height: 170)
            }
        }
    }
}
