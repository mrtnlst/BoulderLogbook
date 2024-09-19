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
    @Reducer(state: .equatable)
    enum Destination {
        case entryDetail(EntryDetail)
        case confirmationDialog(ConfirmationDialogState<Confirmation>)

        @CasePathable
        enum Confirmation {
            case delete
        }
    }

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var sections: [Logbook.Section] = []
        var diagramPage = DiagramPage.State()
        var gradeSystems: [GradeSystem] = []
        var entryToDelete: Logbook.Section.Entry.ID?

        var numberOfEntries: Int {
            sections.reduce(into: 0, { $0 += $1.entries.count})
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
        case diagramPage(DiagramPage.Action)
        case destination(PresentationAction<Destination.Action>)

        enum EntryClientResponse { case finished }
    }
    @Dependency(LogbookEntryClient.self) var logbookEntryClient
    @Dependency(GradeSystemClient.self) var gradeSystemClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Scope(state: \.diagramPage, action: /Action.diagramPage) {
            DiagramPage()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
#if targetEnvironment(simulator)
                return .concatenate(
                    .run { _ in await gradeSystemClient.saveDefaultSystems() },
                    .run { _ in logbookEntryClient.saveBackupEntries() },
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
                state.sections = sections

            case let .delete(id),
                 let .destination(.presented(.entryDetail(.delete(id)))) :
                state.entryToDelete = id
                return .run { send in
                    try await Task.sleep(for: .milliseconds(100))
                    await send(.showDeletionConfirmation)
                }

            case .showDeletionConfirmation:
                state.destination = .confirmationDialog(
                    ConfirmationDialogState {
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
                return .merge(
                    .send(.fetchSections),
                    .send(.diagramPage(.fetchEntries))
                )

            case let .setNavigation(entry):
                if let system = state.gradeSystems.first(where: { $0.id == entry.gradeSystem }) {
                    state.destination = .entryDetail(
                        EntryDetail.State(
                            entry: entry,
                            gradeSystem: system
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
