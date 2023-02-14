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
    let onLongPressGesture: () -> Void
    
    var body: some View {
        VStack {
            picker()
            chart()
                .onLongPressGesture(minimumDuration: 0.2) {
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    onLongPressGesture()
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
            .padding(.bottom, 4)
        }
    }
    
    @ViewBuilder func chart() -> some View {
        WithViewStore(store) { viewStore in
            let grades = viewStore.gradeSystem.grades
            Chart(grades) { grade in
                BarMark(
                    x: .value("Grade", grade.name),
                    y: .value("Tops", viewStore.tops.count(for: grade))
                )
                .foregroundStyle(by: .value("Grade", grade.name))
                .annotation(position: .overlay, alignment: .bottom) {
                    Text("\(viewStore.tops.count(for: grade))")
                        .foregroundColor(grade.color.isBright ? .black : .mandalaWhite)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
            }
            .chartForegroundStyleScale(range: grades.map { $0.color })
            .chartLegend(.hidden)
            .animation(.default, value: viewStore.selectedSegment)
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
                ),
                onLongPressGesture: { print("onLongPressGesture") }
            )
                .frame(height: 170)
        }
    }
}
