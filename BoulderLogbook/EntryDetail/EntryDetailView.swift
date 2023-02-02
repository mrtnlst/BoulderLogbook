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
    let entry: Logbook.Section.Entry
    
    var body: some View {
        Chart {
            ForEach(LegacyBoulderGrade.allCases.reversed(), id: \.self) { grade in
                BarMark(
                    x: .value("Grade", grade.gradeDescription),
                    y: .value("Tops", entry.tops.numberOfGrades(for: grade))
                )
                .foregroundStyle(by: .value("Grade", grade.gradeDescription))
            }
        }
        .chartForegroundStyleScale([
            LegacyBoulderGrade.purple.gradeDescription: LegacyBoulderGrade.purple.color,
            LegacyBoulderGrade.yellow.gradeDescription: LegacyBoulderGrade.yellow.color,
            LegacyBoulderGrade.white.gradeDescription: LegacyBoulderGrade.white.color,
            LegacyBoulderGrade.black.gradeDescription: LegacyBoulderGrade.black.color,
            LegacyBoulderGrade.orange.gradeDescription: LegacyBoulderGrade.orange.color,
            LegacyBoulderGrade.red.gradeDescription: LegacyBoulderGrade.red.color,
            LegacyBoulderGrade.blue.gradeDescription: LegacyBoulderGrade.blue.color
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
                        entry: .samples[0]
                    ),
                    reducer: EntryDetail()
                )
            )
        }
    }
}
