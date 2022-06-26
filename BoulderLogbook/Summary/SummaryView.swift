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
                    SummarySectionView(logbookSection: section)
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
    
    var body: some View {
        Section {
            ForEach(logbookSection.logbookEntries) { entry in
                SummaryEntryView(entry: entry)
            }
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
            HStack {
                ForEach(BoulderGrade.allCases.reverse() , id: \.self) { grade in
                    let numberOfTops = entry.numberOfGrades(for: grade)
                    if numberOfTops > 0 {
                        Image(systemName: grade == .white ? "circle" : "circle.fill")
                            .foregroundColor(grade == .white ? .none : grade.color)
                        Text("× \(numberOfTops)")
                        
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
                        fetch: { return .none }
                    )
                )
            )
        }
    }
}
