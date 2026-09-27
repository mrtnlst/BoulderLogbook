//
//  Dashboard.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Dashboard {
    @Reducer
    enum Destination {
        case entryForm(EntryForm)
        case entryDetail(EntryDetail)
        case confirmationDialog(AlertState<Confirmation>)

        @CasePathable
        enum Confirmation {
            case delete
        }
    }

    @ObservableState
    struct State {
        var trends: TrendsFeature.State
        @Presents var destination: Destination.State?
        @Shared var sections: [Logbook.Section]
        var gradeSystems: [GradeSystem] = []
        var entryToDelete: Logbook.Section.Entry.ID?

        var numberOfEntries: Int {
            sections.reduce(into: 0, { $0 += $1.entries.count})
        }
        
        init() {
            self._sections = Shared(value: [])
            self.trends = .init(sections: self._sections)
        }
    }
    
    enum Action {
        case onAppear
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSections
        case receiveSections(TaskResult<[Logbook.Section]>)
        case showDeletionConfirmation
        case delete(Logbook.Section.Entry.ID)
        case deleteDidFinish(TaskResult<EntryClientResponse>)
        case edit(Logbook.Section.Entry)
        case setNavigation(Logbook.Section.Entry)
        case presentEntryForm(EntryForm.State?)
        case trends(TrendsFeature.Action)
        case destination(PresentationAction<Destination.Action>)

        enum EntryClientResponse { case finished }
    }
    @Dependency(\.logbookEntryClient) var logbookEntryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Scope(state: \.trends, action: \.trends) {
            TrendsFeature()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
#if targetEnvironment(simulator)
                return .concatenate(
                    .run { _ in await gradeSystemClient.saveDefaultSystems() },
                    .run { _ in await logbookEntryClient.saveBackupEntries() },
                    .run { _ in await logbookEntryClient.migrateEntries() },
                    .send(.fetchGradeSystems)
                )
#else
                return .concatenate(
                    .run { _ in await gradeSystemClient.migrateGradeSystems() },
                    .run { _ in await logbookEntryClient.migrateEntries() },
                    .send(.fetchGradeSystems)
                )
#endif
                
            case .fetchGradeSystems:
                return .run { send in
                    await send(
                        .receiveGradeSystems(TaskResult { await gradeSystemClient.fetchAvailableSystems() })
                    )
                }
                
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .send(.fetchSections)

            case .fetchSections:
                return .run { send in
                    await send(
                        .receiveSections(TaskResult { await logbookEntryClient.fetchSections() })
                    )
                }
                
            case let .receiveSections(.success(sections)):
                state.$sections.withLock {
                    $0 = sections
                }

            case let .delete(id),
                 let .destination(.presented(.entryDetail(.delete(id)))) :
                state.entryToDelete = id
                return .run { send in
                    try await Task.sleep(for: .milliseconds(100))
                    await send(.showDeletionConfirmation)
                }

            case .showDeletionConfirmation:
                state.destination = .confirmationDialog(
                    AlertState {
                        TextState("Warning")
                    } actions: {
                        ButtonState(role: .destructive, action: .delete) {
                            TextState("Delete")
                        }
                    } message: {
                        TextState("Are you sure you want to delete this entry?")
                    }
                )

            case .destination(.presented(.confirmationDialog(.delete))):
                guard let entryToDelete = state.entryToDelete else {
                    return .none
                }
                return .run { send in
                    await send(
                        .deleteDidFinish(
                            TaskResult {
                                await logbookEntryClient.deleteEntry(entryToDelete)
                                return .finished
                            }
                        )
                    )
                }

            case .deleteDidFinish:
                state.destination = nil
                return .run { send in
                    await send(.fetchSections)
                }

            case let .setNavigation(entry):
                if let system = state.gradeSystems.first(where: { $0.id == entry.gradeSystem }) {
                    state.destination = .entryDetail(
                        EntryDetail.State(
                            entry: entry,
                            gradeSystem: system
                        )
                    )
                }
            case let .presentEntryForm(entryFormState):
                state.destination = .entryForm(entryFormState ?? EntryForm.State())

            case .destination(.presented(.entryForm(.cancel))):
                state.destination = nil
                
            case .destination(.presented(.entryForm(.saveDidFinish))):
                state.destination = nil
                return .run { send in
                    await send(.fetchSections)
                }
                
            case let .edit(entry),
                let .destination(.presented(.entryDetail(.edit(entry)))):
                return .run { send in
                    try await Task.sleep(for: .milliseconds(100))
                    await send(
                        .presentEntryForm(
                            .init(
                                id: entry.id,
                                date: entry.date,
                                notes: entry.notes,
                                tops: entry.tops.normal(),
                                attempts: entry.tops.filter { $0.isAttempt },
                                flashs: entry.tops.filter { $0.wasFlash },
                                onsights: entry.tops.filter { $0.wasOnsight },
                                selectedSystem: entry.gradeSystem,
                                isEditing: true
                            )
                        )
                    )
                }

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
