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
        var dashboard = Dashboard.State()
        var settings: Settings.State?
        var entryForm: EntryForm.State?
        var isPresentingForm: Bool = false
        var isPresentingSettings: Bool = false
        var path: [StoreOf<EntryDetail>] = []
    }
    
    enum Action {
        case dashboard(Dashboard.Action)
        case settings(Settings.Action)
        case entryForm(EntryForm.Action)
        case setIsPresentingForm(Bool)
        case setIsPresentingSettings(Bool)
        case setPath([StoreOf<EntryDetail>])
    }
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

            case let .setIsPresentingSettings(isPresenting):
                state.settings = isPresenting ? Settings.State() : nil
                state.isPresentingSettings = isPresenting

            case let .setPath(path):
                state.path = path
                
            case .entryForm(.cancel):
                return .send(.setIsPresentingForm(false))
                
            case .entryForm(.saveDidFinish(_)):
                return .merge(
                    .send(.setIsPresentingForm(false)),
                    .send(.dashboard(.fetchEntries))
                )
                
            case .dashboard(.dashboardSection(id: _, action: .entryDetail(id: _, action: .delete(_)))):
                state.path = []
                
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
                    selectedSystem: entry.gradeSystem,
                    isEditing: true
                )
                state.isPresentingForm = true
 
            case .settings(.gradeSystemList(.gradeSystemForm(.saveDidFinish))):
                return .send(.dashboard(.fetchGradeSystems))
                
            case .settings(.deleteEntriesDidFinish):
                return .send(.dashboard(.fetchGradeSystems))
                                
            case .settings(.filterSheet(.saveDidFinish)):
                return .send(.dashboard(.diagramPage(.fetchSelectedSystem)))
                
            default: ()
            }
            return .none
        }
        .ifLet(\.entryForm, action: /Action.entryForm) {
            EntryForm()
        }
        .ifLet(\.settings, action: /Action.settings) {
            Settings()
        }
    }
}
