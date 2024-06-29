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
        PlainList {
            PlainSection {
                SummaryDiagramView(
                    store: store.scope(
                        state: \.summaryDiagram,
                        action: \.summaryDiagram
                    )
                )
                .frame(height: 200)
            }
            PlainSection {
                gradesSystem(name: store.gradeSystem.name)
            }
            PlainSection {
                if let notes = store.entry.notes {
                    self.notes(text: notes)
                } else {
                    EmptyView()
                }
            }
            PlainSection {
                buttons()
            }
        }
        .onAppear { store.send(.onAppear) }
        .navigationTitle(Text(store.entry.date, style: .date))
    }
}

extension EntryDetailView {
    func gradesSystem(name: String) -> some View {
        HStack {
            Label("Grade System", systemImage: "square.fill.text.grid.1x2")
            Spacer()
            Text(name)
        }
        .foregroundStyle(.primaryText)
    }

    func notes(text: String) -> some View {
        Label(text, systemImage: "note.text")
            .foregroundStyle(.primaryText)
    }

    @ViewBuilder
    func buttons() -> some View {
        RectangularButton.edit {
            store.send(.edit(store.entry))
        }
        RectangularButton.delete {
            store.send(.delete(store.entry.id))
        }
    }
}

#Preview {
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
                                grade: Grade.mandalaBlack.id,
                                isAttempt: false,
                                wasFlash: true,
                                wasOnsight: false
                            ),
                            .init(
                                id: UUID(),
                                grade: Grade.mandalaBlack.id,
                                isAttempt: false,
                                wasFlash: false,
                                wasOnsight: false
                            ),
                            .init(
                                id: UUID(),
                                grade: Grade.mandalaBlue.id,
                                isAttempt: false,
                                wasFlash: false,
                                wasOnsight: true
                            ),
                            .init(
                                id: UUID(),
                                grade: Grade.mandalaBlue.id,
                                isAttempt: false,
                                wasFlash: false,
                                wasOnsight: true
                            ),
                            .init(
                                id: UUID(),
                                grade: Grade.mandalaBlue.id,
                                isAttempt: false,
                                wasFlash: false,
                                wasOnsight: true
                            ),
                            .init(
                                id: UUID(),
                                grade: Grade.mandalaRed.id,
                                isAttempt: false,
                                wasFlash: true,
                                wasOnsight: false
                            ),
                            .init(
                                id: UUID(),
                                grade: Grade.mandalaRed.id,
                                isAttempt: false,
                                wasFlash: false,
                                wasOnsight: false
                            )
                        ],
                        gradeSystem: GradeSystem.mandala.id
                    ),
                    gradeSystem: .mandala
                )
            ) {
                EntryDetail()
            }
        )
    }
}
