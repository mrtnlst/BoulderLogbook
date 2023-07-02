//
//  EntryView.swift
//  BoulderLogbook
//
//  Created by Martin List on 14.07.22.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct EntryDetailView: View {
    let store: StoreOf<EntryDetail>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    SummaryDiagramView(
                        store: store.scope(
                            state: \.summaryDiagram,
                            action: EntryDetail.Action.summaryDiagram
                        )
                    )
                    .frame(height: 200)
                }
                Section {
                    gradesSystem(name: viewStore.gradeSystem.name)
                }
                Section {
                    if let notes = viewStore.entry.notes {
                        self.notes(text: notes)
                    } else {
                        EmptyView()
                    }
                }
                Section {
                    buttons()
                }
            }
            .onAppear { viewStore.send(.onAppear) }
            .navigationTitle(Text(viewStore.entry.date, style: .date))
        }
    }
}

extension EntryDetailView {
    func gradesSystem(name: String) -> some View {
        HStack {
            Label(
                title: { Text("Grade System") },
                icon: {
                    Image(systemName: "square.fill.text.grid.1x2")
                        .foregroundColor(.primary)
                }
            )
            Spacer()
            Text(name)
                .foregroundColor(.secondary)
        }
    }
    
    func notes(text: String) -> some View {
        HStack {
            Label(
                title: {
                    Text(text)
                },
                icon: {
                    Image(systemName: "note.text")
                        .foregroundColor(.primary)
                }
            )
        }
    }
    
    func buttons() -> some View {
        WithViewStore(store) { viewStore in
            RectangularButton.edit {
                viewStore.send(.edit(viewStore.entry))
            }
            RectangularButton.delete {
                viewStore.send(.delete(viewStore.entry.id))
            }
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntryDetailView(
                store: Store(
                    initialState: EntryDetail.State(
                        entry: Logbook.Section.Entry.init(
                            date: .now,
                            notes: "Boulder Cup, 22ºC",
                            tops: [
                                .init(
                                    id: UUID(),
                                    grade: GradeSystem.Grade.mandalaBlack.id,
                                    isAttempt: false,
                                    wasFlash: true,
                                    wasOnsight: false
                                ),
                                .init(
                                    id: UUID(),
                                    grade: GradeSystem.Grade.mandalaBlack.id,
                                    isAttempt: false,
                                    wasFlash: false,
                                    wasOnsight: false
                                ),
                                .init(
                                    id: UUID(),
                                    grade: GradeSystem.Grade.mandalaBlue.id,
                                    isAttempt: false,
                                    wasFlash: false,
                                    wasOnsight: true
                                ),
                                .init(
                                    id: UUID(),
                                    grade: GradeSystem.Grade.mandalaBlue.id,
                                    isAttempt: false,
                                    wasFlash: false,
                                    wasOnsight: true
                                ),
                                .init(
                                    id: UUID(),
                                    grade: GradeSystem.Grade.mandalaBlue.id,
                                    isAttempt: false,
                                    wasFlash: false,
                                    wasOnsight: true
                                ),
                                .init(
                                    id: UUID(),
                                    grade: GradeSystem.Grade.mandalaRed.id,
                                    isAttempt: false,
                                    wasFlash: true,
                                    wasOnsight: false
                                ),
                                .init(
                                    id: UUID(),
                                    grade: GradeSystem.Grade.mandalaRed.id,
                                    isAttempt: false,
                                    wasFlash: false,
                                    wasOnsight: false
                                )
                            ],
                            gradeSystem: GradeSystem.mandala.id
                        ),
                        gradeSystem: .mandala
                    ),
                    reducer: EntryDetail()
                )
            )
        }
    }
}
