//
//  EntryView.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import SwiftUI
import ComposableArchitecture
#if canImport(Charts)
import Charts
#endif

struct EntryView: View {
    let store: Store<EntryState, EntryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack {
                    if #available(iOS 16.0, *) {
                        EntryViewChart(entry: viewStore.entry)
                    }
                    SummaryEntryView(entry: viewStore.entry)
                        .frame(height: 80)
                        .padding()
                    Spacer()
    #if canImport(Charts)
                    Button(role: .destructive) {
                        viewStore.send(.delete(viewStore.entry))
                    } label: {
                        Label {
                            Text("Delete Entry")
                        } icon: {
                            Image(systemName: "trash")
                        }
                    }
    #endif
                }
                .navigationTitle(Text(viewStore.entry.date, style: .date))
            }
        }
    }
}

@available(iOS 16.0, *)
struct EntryViewChart: View {
    let entry: LogbookData.Entry
    
    var body: some View {
#if canImport(Charts)
        Chart {
            ForEach(BoulderGrade.allCases.reversed(), id: \.self) { grade in
                BarMark(
                    x: .value("Grade", grade.gradeDescription),
                    y: .value("Tops", entry.numberOfGrades(for: grade))
                )
                .foregroundStyle(by: .value("Grade", grade.gradeDescription))
            }
        }
        .chartForegroundStyleScale([
            BoulderGrade.purple.gradeDescription: BoulderGrade.purple.color,
            BoulderGrade.yellow.gradeDescription: BoulderGrade.yellow.color,
            BoulderGrade.white.gradeDescription: BoulderGrade.white.color,
            BoulderGrade.black.gradeDescription: BoulderGrade.black.color,
            BoulderGrade.orange.gradeDescription: BoulderGrade.orange.color,
            BoulderGrade.red.gradeDescription: BoulderGrade.red.color,
            BoulderGrade.blue.gradeDescription: BoulderGrade.blue.color
        ])
        .chartLegend(.hidden)
        .frame(height: 200)
        .padding()
#else
        EmptyView()
#endif
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntryView(
                store: Store(
                    initialState: .init(entry:             LogbookData.Entry.sampleEntries[0]),
                    reducer: entryReducer,
                    environment: EntryEnvironment()
                )
            )
        }
    }
}
