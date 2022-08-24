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
            List {
                Section {
                    if #available(iOS 16.0, *) {
                        EntryViewChart(entry: viewStore.entry)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            EntryColorView(entry: viewStore.entry)
                                .frame(minHeight: 32)
                            HStack(spacing: 4) {
                                Image(systemName: "arrowtriangle.up.circle")
                                    .font(.callout.weight(.bold))
                                Text("\(viewStore.entry.tops.count) tops")
                                    .font(.callout)
                            }
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.callout.weight(.bold))
                                Text(viewStore.entry.date, format: .dateTime.year().month().day().hour().minute())
                                    .font(.callout)
                            }
                        }
                        .padding(.vertical, 8)
                    }
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
                    initialState: .init(entry: LogbookData.Entry.sampleEntries[0]),
                    reducer: entryReducer,
                    environment: EntryEnvironment()
                )
            )
        }
    }
}
