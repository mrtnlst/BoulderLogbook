//
//  SummaryView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct SummaryView: View {
    let store: Store<SummaryState, SummaryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.logbook.logbookSections) { section in
                    SummarySectionView(
                        logbookSection: section,
                        onDelete: { viewStore.send(.delete(entry: $0, section: section.date)) }
                    )
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle("Summary")
        }
    }
}

struct SummarySectionView: View {
    let logbookSection: LogbookSection
    let onDelete: (IndexSet) -> Void
    
    var body: some View {
        Section {
            ForEach(logbookSection.logbookEntries.sorted(by: { $0.date > $1.date })) { entry in
                SummaryEntryView(entry: entry)
            }
            .onDelete(perform: onDelete)
        } header: {
            Text(logbookSection.date, style: .date)
        }
        .headerProminence(.increased)
    }
}

struct SummaryEntryView: View {
    let entry: LogbookEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if #available(iOS 16, *) {
                    Image(systemName: "figure.climbing")
                } else {
                    Image("figure.climbing")
                }
                Text(entry.date, style: .time)
            }
            Spacer()
            HStack(spacing: 3) {
                ForEach(BoulderGrade.allCases.reversed(), id: \.self) { grade in
                    let numberOfTops = entry.numberOfGrades(for: grade)
                    if numberOfTops > 0 {
                        Image(systemName: grade == .white ? "circle" : "circle.fill")
                            .foregroundColor(grade == .white ? .none : grade.color)
                        Text("×")
                        Text("\(numberOfTops) ")
                    }
                }
            }
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SummaryView(
                store: Store(
                    initialState: SummaryState(
                        logbook: exampleLogbook
                    ),
                    reducer: summaryReducer,
                    environment: SummaryEnvironment(
                        mainQueue: .main,
                        fetch: { return .none },
                        delete: { _, _ in return .none }
                    )
                )
            )
        }
    }
}
