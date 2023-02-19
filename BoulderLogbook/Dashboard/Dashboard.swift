//
//  Dashboard.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct Dashboard: ReducerProtocol {
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
        case dashboardSection(id: Double, action: DashboardSection.Action)
        case diagramPage(DiagramPage.Action)
    }
    @Dependency(\.entryClient) var entryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.diagramPage, action: /Action.diagramPage) {
            DiagramPage()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate(
                    .fireAndForget { gradeSystemClient.saveDefaultSystems() },
                    .fireAndForget { entryClient.saveBackupEntries() },
                    .task { .fetchGradeSystems }
                )
                
            case .fetchGradeSystems:
                return .task {
                    await .receiveGradeSystems(
                        TaskResult { gradeSystemClient.fetchAvailableSystems() }
                    )
                }
                
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .merge(
                    .task { .fetchEntries },
                    .task { .diagramPage(.receiveGradeSystems(gradeSystems)) }
                )
                
            case .fetchEntries:
                return .task {
                    await .receiveEntries(TaskResult { entryClient.fetchEntries() })
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
                return .task { .diagramPage(.receiveEntries(entries)) }
                
            case .dashboardSection(id: _, action: .deleteDidFinish(_)):
                return .task { .fetchEntries }

            default:
                return .none
            }
        }
        .forEach(\.sections, action: /Action.dashboardSection) {
            DashboardSection()
        }
    }
}
