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
        var diagram: Diagram.State = Diagram.State()
        var gradeSystems: [GradeSystem] = []
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchEntries
        case receiveEntries(TaskResult<[Logbook.Section.Entry]>)
        case fetchFilters
        case receiveFilters(TaskResult<[LegacyBoulderGrade]>)
        case dashboardSection(id: Double, action: DashboardSection.Action)
        case diagram(Diagram.Action)
    }
    
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.storageService) var storageService
    @Dependency(\.logbookClient) var logbookClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.diagram, action: /Action.diagram) {
            Diagram()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .concatenate(
                    .fireAndForget { gradeSystemClient.saveDefaultSystems() },
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
                state.diagram.gradeSystems = gradeSystems
                return .merge(
                    .task { .fetchEntries },
                    .task { .fetchFilters }
                )
                
            case .fetchEntries:
                return .task {
                    await .receiveEntries(TaskResult { logbookClient.fetchEntries() })
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
                state.diagram.entries = entries
                return .none
                
            case .fetchFilters:
                return .task {
                    await .receiveFilters(TaskResult { storageService.fetchFilters() })
                }
     
            case .receiveFilters(.success(_)):
//                state.diagramState.filters = filters
                return .none
           
            
            case .dashboardSection(id: _, action: .deleteDidFinish(_)):
                return .task { .fetchEntries }
                
            case let .dashboardSection(id: _, action: .entryDetail(id: _, action: .delete(logbookEntry))):
                return .merge(
                    .fireAndForget { storageService.delete(logbookEntry) },
                    .task { .fetchEntries }
                )
                
            default:
                return .none
            }
        }
        .forEach(\.sections, action: /Action.dashboardSection) {
            DashboardSection()
        }
    }
}
