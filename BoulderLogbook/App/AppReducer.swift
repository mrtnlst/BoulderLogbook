//
//  AppReducer.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppReducer {
    @ObservableState
    struct State {
        var dashboard: Dashboard.State
        var insights: InsightsFeature.State
        var history: HistoryFeature.State
        var settings: Settings.State
        var tab: AppTab = .sessions
        
        @Shared var sections: [Logbook.Section]
        @Shared var gradeSystems: [GradeSystem]
        @Shared(.fileStorage(.defaultGradeSystem)) var defaultGradeSystem: GradeSystem?

        init() {
            self._sections = Shared(value: [])
            self._gradeSystems = Shared(value: [])
            self.dashboard = .init(
                sections: self._sections,
                gradeSystems: self._gradeSystems
            )
            self.insights = .init(sections: self._sections)
            self.history = .init(
                sections: self._sections,
                gradeSystems: self._gradeSystems
            )
            self.settings = .init(
                gradeSystems: self._gradeSystems
            )
        }
    }
    
    enum Action: ViewAction {
        enum View {
            case onAppear
        }
        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        case fetchSections
        case receiveSections(TaskResult<[Logbook.Section]>)

        case dashboard(Dashboard.Action)
        case insights(InsightsFeature.Action)
        case history(HistoryFeature.Action)
        case settings(Settings.Action)
        
        case presentGradeSystemList
        case presentGradeSystemConfiguration
        case didChangeTab(AppTab)
        
        case view(View)
    }
    @Dependency(\.logbookEntryClient) var logbookEntryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient

    var body: some Reducer<State, Action> {
        Scope(state: \.dashboard, action: \.dashboard) {
            Dashboard()
        }
        Scope(state: \.insights, action: \.insights) {
            InsightsFeature()
        }
        Scope(state: \.history, action: \.history) {
            HistoryFeature()
        }
        Scope(state: \.settings, action: \.settings) {
           Settings()
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
#if targetEnvironment(simulator)
                state.$defaultGradeSystem.withLock {
                    $0 = .mandala2
                }
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
                state.$gradeSystems.withLock {
                    $0 = gradeSystems
                }
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

            case .presentGradeSystemList:
                return .send(.settings(.setGradeSystemListNavigation))

            case .presentGradeSystemConfiguration:
                return .send(.settings(.setGradeSystemListNavigation))
                
            case .insights(.ascendInsights(.view(.didTapSelectFocusGrade))):
                state.tab = .settings
                return .send(.presentGradeSystemList)
                
            case .dashboard(.destination(.presented(.newEntry(.saveDidFinish)))),
                 .history(.delegate(.fetchSections)):
                return .run { send in
                    await send(.fetchSections)
                }
                
            case .settings(.delegate(.fetchGradeSystems)):
                return .run { send in
                    await send(.fetchGradeSystems)
                }
                
            case let .didChangeTab(tab):
                state.tab = tab

            default: ()
            }
            return .none
        }
    }
}
