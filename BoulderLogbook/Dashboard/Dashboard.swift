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
    @ObservableState
    struct State: Equatable {
        @Presents var entryDetail: EntryDetail.State?
        var sections: [Logbook.Section] = []
        var diagramPage = DiagramPage.State()
        var gradeSystems: [GradeSystem] = []

        var numberOfEntries: Int {
            sections.reduce(into: 0, { $0 += $1.entries.count})
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSections
        case receiveSections(TaskResult<[Logbook.Section]>)
        case delete(Logbook.Section.Entry.ID)
        case deleteDidFinish(TaskResult<EntryClientResponse>)
        case edit(Logbook.Section.Entry)
        case setNavigation(Logbook.Section.Entry)
        case entryDetail(PresentationAction<EntryDetail.Action>)
        case diagramPage(DiagramPage.Action)

        enum EntryClientResponse { case finished }
    }
    @Dependency(LogbookEntryClient.self) var logbookEntryClient
    @Dependency(GradeSystemClient.self) var gradeSystemClient
    
    var body: some Reducer<State, Action> {
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
                state.sections = sections.sorted(
                    by: { $0.date > $1.date }
                )
                
            case let .delete(id),
                 let .entryDetail(.presented(.delete(id))):
                return .run { send in
                    await send(
                        .deleteDidFinish(
                            TaskResult {
                                await logbookEntryClient.deleteEntry(id)
                                return .finished
                            }
                        )
                    )
                }

            case .deleteDidFinish:
                state.entryDetail = nil
                return .merge(
                    .send(.fetchSections),
                    .send(.diagramPage(.fetchEntries))
                )
                
            case let .setNavigation(entry):
                if let system = state.gradeSystems.first(where: { $0.id == entry.gradeSystem }) {
                    state.entryDetail = EntryDetail.State(
                        entry: entry,
                        gradeSystem: system
                    )
                }

            default: ()
            }
            return .none
        }
        .ifLet(\.$entryDetail, action: \.entryDetail) {
            EntryDetail()
        }
    }
}
