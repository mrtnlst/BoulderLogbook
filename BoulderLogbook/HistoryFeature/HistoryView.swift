//
//  HistoryView.swift
//  BoulderLogbook
//
//  Created by Martin List on 04.10.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: HistoryFeature.self)
struct HistoryView: View {
    @Bindable var store: StoreOf<HistoryFeature>
    
    var body: some View {
        NavigationStack {
            PlainList {
                ForEach(store.sections, id: \.date) {
                    section($0)
                }
                TotalAmountView(amount: store.numberOfEntries)
                CreditsView()
            }
            .navigationTitle("History")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.entryDetail,
                    action: \.destination.entryDetail
                )
            ) {
                EntryDetailView(store: $0)
            }
            .sheet(
                item: $store.scope(
                    state: \.destination?.entryForm,
                    action:  \.destination.entryForm
                )
            ) {
                EntryFormView(store: $0)
            }
            .alert(
                $store.scope(
                    state: \.destination?.confirmationDialog,
                    action: \.destination.confirmationDialog
                )
            )
        }
    }
}

private extension HistoryView {
    func section(_ section: Logbook.Section) -> some View {
        PlainSection {
            ForEach(section.entries) { entry in
                if let gradeSystem = store.gradeSystems.first(
                    where: { $0.id == entry.gradeSystem }
                ) {
                    row(entry: entry, gradeSystem: gradeSystem)
                }
            }
        } header: {
            Text(
                section.date,
                format: .dateTime.year().month(.wide)
            )
            .font(.title3)
            .fontWeight(.semibold)
        }
    }

    func row(
        entry: Logbook.Section.Entry,
        gradeSystem: GradeSystem
    ) -> some View {
        PlainRowButton {
            send(.setNavigation(entry))
        } label: {
            DashboardEntryView(
                entry: entry,
                gradeSystem: gradeSystem,
                focusGrade: store.focusGrade
            )
        }
        .swipeActions {
            Button {
                send(.delete(entry.id))
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.araError)
            Button {
                send(.edit(entry))
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.araWarning)
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView(
            store: Store(
                initialState: HistoryFeature.State(
                    sections: Shared(
                        value: Logbook.sample2.sections
                    ),
                    gradeSystems: Shared(value: [.mandala2])
                )
            ) {
                HistoryFeature()
            }
        )
    }
}
