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
                    chart(tops: viewStore.entry.tops, gradeSystem: viewStore.gradeSystem)
                }
                Section {
                    gradesSystem()
                }
                Section {
                    buttons()
                }
            }
            .navigationTitle(Text(viewStore.entry.date, style: .date))
        }
    }
}

extension EntryDetailView {
    @ViewBuilder func chart(tops: [Top], gradeSystem: GradeSystem) -> some View {
        let grades = tops.successful().grades(for: gradeSystem)
        Chart {
            ForEach(gradeSystem.grades, id: \.self) { grade in
                BarMark(
                    x: .value("Grade", grade.name),
                    y: .value("Tops", grades.filter { $0 == grade }.count)
                )
                .foregroundStyle(by: .value("Grade", grade.name))
            }
        }
        .chartForegroundStyleScale(range: gradeSystem.grades.map { $0.color })
        .chartLegend(.hidden)
        .frame(height: 200)
    }
    
    @ViewBuilder func gradesSystem() -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Label(
                    title: { Text("Grade System") },
                    icon: {
                        Image(systemName: "square.fill.text.grid.1x2")
                            .foregroundColor(.primary)
                    }
                )
                Spacer()
                Text(viewStore.gradeSystem.name)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder func buttons() -> some View {
        WithViewStore(store) { viewStore in
            RectangularButton.edit {
                viewStore.send(.edit(viewStore.entry))
            }
            RectangularButton.delete {
                viewStore.send(.delete(viewStore.entry.id))
            }
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntryDetailView(
                store: Store(
                    initialState: EntryDetail.State(
                        entry: [Logbook.Section.Entry].samples[0],
                        gradeSystem: .mandala
                    ),
                    reducer: EntryDetail()
                )
            )
        }
    }
}
