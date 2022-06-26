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
                    SummaryLogView(logbookSection: section)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle("Summary")
        }
    }
}

struct SummaryLogView: View {
    let logbookSection: LogbookSection
    
    var body: some View {
        Section {
            ForEach(logbookSection.logbookEntries) { entry in
                Text(entry.logText)
            }
        } header: {
            Text(logbookSection.date, style: .date)
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
