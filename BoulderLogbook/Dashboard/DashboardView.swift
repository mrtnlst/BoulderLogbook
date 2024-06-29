//
//  DashboardView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct DashboardView: View {
    @Bindable var store: StoreOf<Dashboard>
    
    var body: some View {
        PlainList {
            DiagramPageView(
                store: store.scope(
                    state: \.diagramPage,
                    action: \.diagramPage
                )
            )
            ForEach(store.sections, id: \.date) {
                section($0)
            }
            TotalAmountView(amount: store.numberOfEntries)
            CreditsView()
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationTitle("Dashboard")
        .navigationDestination(
            item: $store.scope(state: \.entryDetail, action: \.entryDetail)
        ) {
            EntryDetailView(store: $0)
        }
    }
}

private extension DashboardView {
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
        Button {
            store.send(.setNavigation(entry))
        } label: {
            DashboardEntryView(
                entry: entry,
                gradeSystem: gradeSystem
            )
        }
        .swipeActions {
            Button(role: .destructive) {
                store.send(.delete(entry.id))
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .tint(.araError)
            Button {
                store.send(.edit(entry))
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.araWarning)
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView(
            store: Store(
                initialState: Dashboard.State()
            ) {
                Dashboard()
            }
        )
    }
}
