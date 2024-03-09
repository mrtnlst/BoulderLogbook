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
    struct State: Equatable {
        var sections: IdentifiedArrayOf<DashboardSection.State> = []
        var diagramPage = DiagramPage.State()
        var gradeSystems: [GradeSystem] = []
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSections
        case receiveSections(TaskResult<[Logbook.Section]>)
        case dashboardSection(IdentifiedActionOf<DashboardSection>)
        case diagramPage(DiagramPage.Action)
    }
    @Dependency(\.logbookEntryClient) var logbookEntryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
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
                state.sections = .init(
                    uniqueElements: sections.map { section in
                        DashboardSection.State(
                            date: section.date,
                            entries: section.entries,
                            gradeSystems: state.gradeSystems
                        )
                    }.sorted(
                        by: { $0.date > $1.date }
                    )
                )
                
            case .dashboardSection(.element(_, .deleteDidFinish(_))):
                return .merge(
                    .send(.fetchSections),
                    .send(.diagramPage(.fetchEntries))
                )
                
            default: ()
            }
            return .none
        }
        .forEach(\.sections, action: \.dashboardSection) {
            DashboardSection()
        }
    }
}
