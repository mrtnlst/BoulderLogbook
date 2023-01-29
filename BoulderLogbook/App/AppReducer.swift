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
        var entryFormState: EntryForm.State?
        var entryForm: EntryForm.State?
        var filterSheet: FilterSheet.State?
        var isPresentingForm: Bool = false
        var isPresentingFilter: Bool = false
        var path: [StoreOf<EntryDetail>] = []
    }
    
    enum Action {
        case dashboard(Dashboard.Action)
        case entryForm(EntryForm.Action)
        case filterSheet(FilterSheet.Action)
        case setIsPresentingForm(Bool)
        case setIsPresentingFilter(Bool)
        case setPath([StoreOf<EntryDetail>])
    }
    
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.continuousClock) var clock

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
                state.filterSheet = isPresenting ? FilterSheet.State() : nil
                state.isPresentingFilter = isPresenting
                return .none
                
            case let .setPath(path):
                state.path = path
                return .none
                
            case .entryForm(.cancel):
                return EffectPublisher(value: .setIsPresentingForm(false))
                
            case .entryForm(.save):
                return .merge(
                    EffectPublisher(value: .setIsPresentingForm(false)),
                    EffectPublisher(value: .dashboard(.fetch))
                )
                
            case .entryForm(_):
                return .none
                
            case .dashboard(.dashboardSection(id: _, action: .entryDetail(id: _, action: .delete(_)))):
                state.path = []
                return .none
                
            case let .dashboard(.dashboardSection(id: _, action: .edit(entry))),
                let .dashboard(.dashboardSection(id: _, action: .entryDetail(id: _, action: .edit(entry)))):
                state.path = []
                state.entryForm = EntryForm.State(entry: entry, isNewEntry: false)
                state.isPresentingForm = true
                return .none
                
            case .dashboard(.presentFilters):
                return EffectPublisher(value: .setIsPresentingFilter(true))
                
            case .dashboard(_):
                return .none
                
            case .filterSheet(.filter(_, .setIsOn(_))):
                return .task {
                    try await self.clock.sleep(for: .milliseconds(500))
                    return .dashboard(.fetchFilters)
                }
                
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
    }
}
