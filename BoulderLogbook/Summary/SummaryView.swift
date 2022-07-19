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
#if canImport(Charts)
        if #available(iOS 16, *) {
            summaryList(with: store)
                .navigationDestination(
                    for: Store<SummaryDetailState, SummaryDetailAction>.self
                ) { detailStore in
                    SummaryDetailView(store: detailStore)
                }
        }
#else
        summaryList(with: store)
#endif
    }
}

extension SummaryView {
    @ViewBuilder func summaryList(with store: Store<SummaryState, SummaryAction>) -> some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    if !viewStore.logbook.logbookEntries.isEmpty {
                        BarChartView(logbook: viewStore.logbook)
                            .frame(minHeight: 150)
                            .padding(.vertical, 8)
                    }
                }
                ForEachStore(
                    store.scope(
                        state: \.summaryDetails,
                        action: SummaryAction.summaryDetailAction(id:action:))
                ) { detailStore in
                    Section {
#if canImport(Charts)
                        if #available(iOS 16, *) {
                            NavigationLink(value: detailStore) {
                                SummaryEntryView(entry: ViewStore(detailStore).logbookEntry)
                            }
                        }
#else
                        SummaryEntryView(entry: ViewStore(detailStore).logbookEntry)
#endif
                    } header: {
                        Text(ViewStore(detailStore).logbookEntry.date, style: .date)
                    }
                    .headerProminence(.increased)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewStore.send(.delete(ViewStore(detailStore).logbookEntry))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            viewStore.send(.edit(ViewStore(detailStore).logbookEntry))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }                
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle("Summary")
        }
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
            .padding(.bottom, 2)
            
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
        if #available(iOS 16.0, *) {
#if canImport(Charts)
            NavigationStack {
                SummaryView(
                    store: Store(
                        initialState: SummaryState(
                            logbook: exampleLogbook
                        ),
                        reducer: summaryReducer,
                        environment: SummaryEnvironment(
                            mainQueue: .main,
                            fetch: { return .none },
                            delete: { _ in return .none }
                        )
                    )
                )
            }
#else
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
                            delete: { _ in return .none }
                        )
                    )
                )
            }
#endif
        }
    }
}
