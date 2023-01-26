//
//  EntryView.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct EntryDetailView: View {
    let store: StoreOf<EntryDetail>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    EntryViewChart(entry: viewStore.entry)
                }
                Section {
                    Button {
                        viewStore.send(.edit(viewStore.entry))
                    } label: {
                        Label {
                            Text("Edit")
                        } icon: {
                            Image(systemName: "pencil")
                        }
                    }
                    Button(role: .destructive) {
                        viewStore.send(.delete(viewStore.entry))
                    } label: {
                        Label {
                            Text("Delete")
                        } icon: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(Text(viewStore.entry.date, style: .date))
        }
    }
}

struct EntryViewChart: View {
    let entry: Logbook.Entry
    
    var body: some View {
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
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntryDetailView(
                store: Store(
                    initialState: EntryDetail.State(
                        entry: Logbook.Entry.sampleEntries[0]
                    ),
                    reducer: EntryDetail()
                )
            )
        }
    }
}
