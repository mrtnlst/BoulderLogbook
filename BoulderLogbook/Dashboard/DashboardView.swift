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
        NavigationStack {
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
            .navigationTitle("Training")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.entryDetail,
                    action: \.destination.entryDetail
                )
            ) {
                EntryDetailView(store: $0)
            }
            .toolbar {
                toolbarContent()
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
        PlainRowButton {
            store.send(.setNavigation(entry))
        } label: {
            DashboardEntryView(
                entry: entry,
                gradeSystem: gradeSystem
            )
        }
        .swipeActions {
            Button {
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
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                store.send(.presentEntryForm(nil))
            } label: {
                if #available(iOS 26, *) {
                    Label("Add entry", systemImage: "plus")
                } else {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
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
