//
//  AppReducer.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct AppReducer: ReducerProtocol {
    struct State: Equatable {
        var dashboard: Dashboard.State = Dashboard.State()
        var settings: Settings.State?
        var entryForm: EntryForm.State?
        var filterSheet: FilterSheet.State?
        var isPresentingForm: Bool = false
        var isPresentingFilter: Bool = false
        var isPresentingSettings: Bool = false
        var path: [StoreOf<EntryDetail>] = []
    }
    
    enum Action {
        case dashboard(Dashboard.Action)
        case settings(Settings.Action)
        case entryForm(EntryForm.Action)
        case filterSheet(FilterSheet.Action)
        case setIsPresentingForm(Bool)
        case setIsPresentingFilter(Bool)
        case setIsPresentingSettings(Bool)
        case setPath([StoreOf<EntryDetail>])
        case deleteEntriesDidFinish(TaskResult<EntryClientResponse>)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.continuousClock) var clock
    @Dependency(\.entryClient) var entryClient

    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.dashboard, action: /Action.dashboard) {
            Dashboard()
        }
        
        Reduce { state, action in
            switch action {
            case let .setIsPresentingForm(isPresenting):
                state.entryForm = isPresenting ? EntryForm.State() : nil
                state.isPresentingForm = isPresenting
                return .none
                
            case let .setIsPresentingFilter(isPresenting):
                // TODO: Maybe move to Dashboard?
                let systems = state.dashboard.gradeSystems
                state.filterSheet = isPresenting ? FilterSheet.State(gradeSystems: systems) : nil
                state.isPresentingFilter = isPresenting
                return .none
                
            case let .setIsPresentingSettings(isPresenting):
                state.settings = isPresenting ? Settings.State() : nil
                state.isPresentingSettings = isPresenting
                return .none
                
            case let .setPath(path):
                state.path = path
                return .none
                
            case .entryForm(.cancel):
                return EffectPublisher(value: .setIsPresentingForm(false))
                
            case .entryForm(.saveDidFinish(_)):
                return .merge(
                    EffectPublisher(value: .setIsPresentingForm(false)),
                    EffectPublisher(value: .dashboard(.fetchEntries))
                )
                
            case .entryForm(_):
                return .none
                
            case .dashboard(.dashboardSection(id: _, action: .entryDetail(id: _, action: .delete(_)))):
                state.path = []
                return .none
                
            case let .dashboard(.dashboardSection(id: _, action: .edit(entry))),
                let .dashboard(.dashboardSection(id: _, action: .entryDetail(id: _, action: .edit(entry)))):
                state.path = []
                state.entryForm = .init(
                    id: entry.id,
                    date: entry.date,
                    tops: entry.tops.normal(),
                    attempts: entry.tops.filter { $0.isAttempt },
                    flashs: entry.tops.filter { $0.wasFlash },
                    onsights: entry.tops.filter { $0.wasOnsight },
                    selectedSystem: entry.gradeSystem
                )
                state.isPresentingForm = true
                return .none
                
            case .dashboard(.diagram(.presentFilters)):
                return EffectPublisher(value: .setIsPresentingFilter(true))
                
            case .dashboard(_):
                return .none
                
            case .settings(.gradeSystemList(.gradeSystemForm(.saveDidFinish(_)))):
                return .task { .dashboard(.fetchGradeSystems) }
                
            case let .settings(.gradeSystemList(.delete(id))):
                return .task {
                    await .deleteEntriesDidFinish(
                        TaskResult {
                            entryClient.deleteEntries(id)
                            return .finished
                        }
                    )
                }
                
            case .deleteEntriesDidFinish(_):
                return .task { .dashboard(.fetchGradeSystems) }
                
            case .filterSheet(.saveFilters):
                return .task { .dashboard(.fetchFilters) }
                
            case .settings(_):
                return .none
                
            case .filterSheet(_):
                return .none
            }
        }
        .ifLet(\.entryForm, action: /Action.entryForm) {
            EntryForm()
        }
        .ifLet(\.filterSheet, action: /Action.filterSheet) {
            FilterSheet()
        }
        .ifLet(\.settings, action: /Action.settings) {
            Settings()
        }
    }
}
