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
    @Reducer
    struct Destination {
        enum State: Equatable {
            case settings(Settings.State)
            case entryForm(EntryForm.State)
        }
        enum Action {
            case settings(Settings.Action)
            case entryForm(EntryForm.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.settings, action: \.settings) {
                Settings()
            }
            Scope(state: \.entryForm, action: \.entryForm) {
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
        case presentGradeSystemList
        case presentGradeSystemConfiguration
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

            case .presentGradeSystemList:
                state.destination = .settings(Settings.State())
                return .send(.destination(.presented(.settings(.setGradeSystemListNavigation))))

            case .presentGradeSystemConfiguration:
                state.destination = .settings(Settings.State())
                return .send(.destination(.presented(.settings(.setGradeSystemListNavigation))))

            case .destination(.presented(.entryForm(.cancel))):
                state.destination = nil
                
            case .destination(.presented(.entryForm(.saveDidFinish))):
                state.destination = nil
                return .merge(
                    .send(.dashboard(.fetchEntries)),
                    .send(.dashboard(.diagramPage(.fetchEntries)))
                )
                
            case let .dashboard(.dashboardSection(.element(_, .edit(entry)))):
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
 
            case .destination(.presented(.settings(.destination(.presented(.gradeSystemList(.destination(.presented(.gradeSystemForm(.saveDidFinish))))))))):
                return .merge(
                    .send(.dashboard(.fetchGradeSystems)),
                    .send(.dashboard(.diagramPage(.fetchGradeSystems)))
                )
                
            case .destination(.presented(.settings(.deleteEntriesDidFinish))):
                return .merge(
                    .send(.dashboard(.fetchGradeSystems)),
                    .send(.dashboard(.diagramPage(.fetchEntries)))
                )
                                
            case .destination(.presented(.settings(.destination(.presented(.gradeSystemList(.saveSelectedDidFinish)))))):
                return .send(.dashboard(.diagramPage(.fetchEntries)))
                
            case .dashboard(.diagramPage(.topCountDiagram(.didPressEmptyView))),
                 .dashboard(.diagramPage(.summaryDiagram(.didPressEmptyView))):
                if !state.dashboard.gradeSystems.isEmpty {
                    return .send(.presentGradeSystemConfiguration)
                }
                return .send(.presentGradeSystemList)

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination) {
          Destination()
        }
    }
}
