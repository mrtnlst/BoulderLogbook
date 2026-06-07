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
        var dashboard = Dashboard.State()
        var insights = InsightsFeature.State()
        var settings = Settings.State()
        var tab: AppTab = .sessions
    }
    
    enum Action {
        case dashboard(Dashboard.Action)
        case insights(InsightsFeature.Action)
        case settings(Settings.Action)
        case presentGradeSystemList
        case presentGradeSystemConfiguration
        case didChangeTab(AppTab)
    }
    @Dependency(\.logbookEntryClient) var entryClient

    var body: some Reducer<State, Action> {
        Scope(state: \.dashboard, action: \.dashboard) {
            Dashboard()
        }
        Scope(state: \.insights, action: \.insights) {
            InsightsFeature()
        }
        Scope(state: \.settings, action: \.settings) {
           Settings()
        }
        Reduce { state, action in
            switch action {

            case .presentGradeSystemList:
                return .send(.settings(.setGradeSystemListNavigation))

            case .presentGradeSystemConfiguration:
                return .send(.settings(.setGradeSystemListNavigation))

            case .settings(.destination(.presented(.gradeSystemList(.destination(.presented(.gradeSystemForm(.saveDidFinish))))))):
                return .merge(
                    .send(.dashboard(.fetchGradeSystems)),
                    .send(.dashboard(.diagramPage(.fetchSelectedSystem)))
                )
                
            case .settings(.deleteEntriesDidFinish):
                return .merge(
                    .send(.dashboard(.fetchGradeSystems)),
                    .send(.dashboard(.diagramPage(.fetchEntries)))
                )
                                
            case .settings(.destination(.presented(.gradeSystemList(.saveSelectedDidFinish)))):
                return .send(.dashboard(.diagramPage(.fetchEntries)))
                
            case .dashboard(.diagramPage(.topCountDiagram(.didPressEmptyView))),
                 .dashboard(.diagramPage(.summaryDiagram(.didPressEmptyView))):
                state.tab = .settings
                if !state.dashboard.gradeSystems.isEmpty {
                    return .send(.presentGradeSystemConfiguration)
                }
                return .send(.presentGradeSystemList)
                
            case let .didChangeTab(tab):
                state.tab = tab

            default: ()
            }
            return .none
        }
    }
}
