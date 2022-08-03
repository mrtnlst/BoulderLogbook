//
//  SummarySectionView.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import SwiftUI
import ComposableArchitecture

struct SummarySectionView: View {
    let store: Store<SummarySectionState, SummarySectionAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Section {
                ForEachStore(
                    store.scope(
                        state: \.summaryDetails,
                        action: SummarySectionAction.summaryDetailAction(id:action:))
                ) { detailStore in
                    
#if canImport(Charts)
                    if #available(iOS 16, *) {
                        NavigationLink(value: detailStore) {
                            SummaryEntryView(entry: ViewStore(detailStore).logbookEntry)
                        }
                    }
#else
                    SummaryEntryView(entry: ViewStore(detailStore).logbookEntry)
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
#endif
                }
            } header: {
                Text(viewStore.date, format: .dateTime.year().month(.wide))
            }
            .headerProminence(.increased)
        }
    }
}

struct SummaryEntryView: View {
    let entry: LogbookEntry
    
    var body: some View {
        HStack {
            if #available(iOS 16, *) {
                Image(systemName: "figure.climbing")
            } else {
                Image("figure.climbing")
                    .foregroundColor(.accentColor)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.accentColor.opacity(0.15))

                    }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    HStack(spacing: 0) {
                        ForEach(entry.tops, id: \.self) { $0.color }
                    }
                    .cornerRadius(8)
                    
                    HStack(spacing: 2) {
                        Image(systemName: "arrowtriangle.up.circle")
                            .font(.footnote.weight(.bold))
                        Text("×")
                            .font(.footnote.weight(.medium))
                        Text("\(entry.tops.count)")
                            .font(.footnote.weight(.medium))
                    }
                }
                
                HStack {
                    Text(entry.date, format: .dateTime.year().month().day().hour().minute())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 2)
            }
        }
    }
}


struct SummarySectionView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SummarySectionView(
                store: Store(
                    initialState: .init(
                        date: .now,
                        summaryDetails: [
                            .init(logbookEntry: exampleLogbook.logbookEntries[0]),
                            .init(logbookEntry: exampleLogbook.logbookEntries[2])
                        ]
                    ),
                    reducer: summarySectionReducer,
                    environment: SummarySectionEnvironment()
                )
            )
        }
    }
}
