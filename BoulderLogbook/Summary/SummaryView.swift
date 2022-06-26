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
                Section {
                    ForEach(viewStore.logbookEntries) { entry in
                        SummaryLogView(logbookEntry: entry)
                    }
                } header: {
                    Text("Logbook")
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .headerProminence(.increased)
            }
            .navigationTitle("Summary")
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SummaryView(
                store: Store(
                    initialState: SummaryState(
                        logbookEntries: exampleLogbook
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

struct SummaryLogView: View {
    let logbookEntry: LogbookEntry
    
    var body: some View {
        HStack {
            Text(logbookEntry.logText)
            Spacer()
            VStack {
                Text(logbookEntry.date, style: .date)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}
