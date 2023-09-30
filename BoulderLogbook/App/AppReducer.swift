//
//  AppReducer.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct AppReducer: Reducer {
    struct Destination: Reducer {
        enum State: Equatable {
            case settings(Settings.State)
            case entryForm(EntryForm.State)
        }
        enum Action {
            case settings(Settings.Action)
            case entryForm(EntryForm.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: /State.settings, action: /Action.settings) {
                Settings()
            }
            Scope(state: /State.entryForm, action: /Action.entryForm) {
                EntryForm()
            }
        }
    }
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
        var dashboard = Dashboard.State()
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case dashboard(Dashboard.Action)
        case presentEntryForm
        case presentSettings
    }
    @Dependency(\.entryClient) var entryClient

    var body: some Reducer<State, Action> {
        Scope(state: \.dashboard, action: /Action.dashboard) {
            Dashboard()
        }
        Reduce { state, action in
            switch action {
            case .presentEntryForm:
                state.destination = .entryForm(EntryForm.State())

            case .presentSettings:
                state.destination = .settings(Settings.State())

            case .destination(.presented(.entryForm(.cancel))):
                state.destination = nil
                
            case .destination(.presented(.entryForm(.saveDidFinish))):
                state.destination = nil
                return .merge(
                    .send(.dashboard(.fetchEntries)),
                    .send(.dashboard(.diagramPage(.fetchEntries)))
                )
                
            case let .dashboard(.dashboardSection(id: _, action: .edit(entry))):
                state.destination = .entryForm(
                    .init(
                        id: entry.id,
                        date: entry.date,
                        notes: entry.notes,
                        tops: entry.tops.normal(),
                        attempts: entry.tops.filter { $0.isAttempt },
                        flashs: entry.tops.filter { $0.wasFlash },
                        onsights: entry.tops.filter { $0.wasOnsight },
                        selectedSystem: entry.gradeSystem,
                        isEditing: true
                    )
                )
 
            case .destination(.presented(.settings(.destination(.presented(.gradeSystemList(.gradeSystemForm(.saveDidFinish))))))):
                return .merge(
                    .send(.dashboard(.fetchGradeSystems)),
                    .send(.dashboard(.diagramPage(.fetchGradeSystems)))
                )
                
            case .destination(.presented(.settings(.deleteEntriesDidFinish))):
                return .merge(
                    .send(.dashboard(.fetchGradeSystems)),
                    .send(.dashboard(.diagramPage(.fetchEntries)))
                )
                                
            case .destination(.presented(.settings(.destination(.presented(.diagramConfiguration(.saveDidFinish)))))):
                return .send(.dashboard(.diagramPage(.fetchSelectedSystem)))
                
            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: /Action.destination) {
          Destination()
        }
    }
}
