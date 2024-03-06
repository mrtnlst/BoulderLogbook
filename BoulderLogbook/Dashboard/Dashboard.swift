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
        case fetchEntries
        case receiveEntries(TaskResult<[Logbook.Section.Entry]>)
        case dashboardSection(IdentifiedActionOf<DashboardSection>)
        case diagramPage(DiagramPage.Action)
    }
    @Dependency(\.entryClient) var entryClient
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
                    .run { _ in gradeSystemClient.saveDefaultSystems() },
                    .run { _ in entryClient.saveBackupEntries() },
                    .send(.fetchGradeSystems)
                )
#else
                return .concatenate(
                    .run { _ in gradeSystemClient.migrateGradeSystems() },
                    .send(.fetchGradeSystems)
                )
#endif
                
            case .fetchGradeSystems:
                return .run { send in
                    await send(
                        .receiveGradeSystems(TaskResult { gradeSystemClient.fetchAvailableSystems() })
                    )
                }
                
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .send(.fetchEntries)
                
            case .fetchEntries:
                return .run { send in
                    await send(
                        .receiveEntries(TaskResult { entryClient.fetchEntries() })
                    )
                }
                
            case let .receiveEntries(.success(entries)):
                let sections = entries.reduce(into: [Logbook.Section]()) { partialResult, entry in
                    guard let sectionDate = entry.date.yearMonthDate else {
                        return
                    }
                    if let indexOfSection = partialResult.firstIndex(where: { $0.date == sectionDate }) {
                        partialResult[indexOfSection].entries.append(entry)
                    } else {
                        partialResult.append(
                            .init(
                                date: sectionDate,
                                entries: [entry]
                            )
                        )
                    }
                }
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
                    .send(.fetchEntries),
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
