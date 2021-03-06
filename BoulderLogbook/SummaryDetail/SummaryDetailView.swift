//
//  SummaryDetailView.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import SwiftUI
import ComposableArchitecture
#if canImport(Charts)
import Charts
#endif

struct SummaryDetailView: View {
    let store: Store<SummaryDetailState, SummaryDetailAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if #available(iOS 16.0, *) {
                    SummaryDetailChart(logbookEntry: viewStore.logbookEntry)
                }
                SummaryEntryView(entry: viewStore.logbookEntry)
                Spacer()
#if canImport(Charts)
                Button {
                    viewStore.send(.didSelectBackButton)
                } label: {
                    Text("Back to Summary")
                        .foregroundColor(.orange)
                }
#endif
            }
            .navigationTitle(Text(viewStore.logbookEntry.date, style: .date))
        }
    }
}

@available(iOS 16.0, *)
struct SummaryDetailChart: View {
    let logbookEntry: LogbookEntry
    
    var body: some View {
#if canImport(Charts)
        Chart {
            ForEach(BoulderGrade.allCases.reversed(), id: \.self) { grade in
                BarMark(
                    x: .value("Grade", grade.gradeDescription),
                    y: .value("Tops", logbookEntry.numberOfGrades(for: grade))
                )
                .foregroundStyle(by: .value("Grade", grade.gradeDescription))
            }
        }
        .chartForegroundStyleScale([
            BoulderGrade.yellow.gradeDescription: BoulderGrade.yellow.color,
            BoulderGrade.white.gradeDescription: BoulderGrade.white.color,
            BoulderGrade.black.gradeDescription: BoulderGrade.black.color,
            BoulderGrade.orange.gradeDescription: BoulderGrade.orange.color,
            BoulderGrade.red.gradeDescription: BoulderGrade.red.color,
            BoulderGrade.blue.gradeDescription: BoulderGrade.blue.color,
        ])
        .chartLegend(.hidden)
        .frame(maxHeight: 200)
        .padding()
#else
        EmptyView()
#endif
    }
}

struct SummaryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SummaryDetailView(
                store: Store(
                    initialState: .init(logbookEntry: exampleLogbook.logbookEntries[0]),
                    reducer: summaryDetailReducer,
                    environment: SummaryDetailEnvironment()
                )
            )
        }
    }
}
