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
    @Reducer(state: .equatable)
    enum Destination {
        case settings(Settings)
        case entryForm(EntryForm)
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var dashboard = Dashboard.State()
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case dashboard(Dashboard.Action)
        case presentEntryForm(EntryForm.State?)
        case presentSettings
        case presentGradeSystemList
        case presentGradeSystemConfiguration
    }
    @Dependency(LogbookEntryClient.self) var entryClient

    var body: some Reducer<State, Action> {
        Scope(state: \.dashboard, action: /Action.dashboard) {
            Dashboard()
        }
        Reduce { state, action in
            switch action {
            case let .presentEntryForm(entryFormState):
                state.destination = .entryForm(entryFormState ?? EntryForm.State())

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
                    .send(.dashboard(.fetchSections)),
                    .send(.dashboard(.diagramPage(.fetchEntries)))
                )
                
            case let .dashboard(.edit(entry)),
                 let .dashboard(.entryDetail(.presented(.edit(entry)))):
                state.dashboard.entryDetail = nil
                return .concatenate(
                    .run { send in try await Task.sleep(for: .milliseconds(100))
                        await send(
                            .presentEntryForm(
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
                        )
                    }
                )

            case .destination(.presented(.settings(.destination(.presented(.gradeSystemList(.destination(.presented(.gradeSystemForm(.saveDidFinish))))))))):
                return .merge(
                    .send(.dashboard(.fetchGradeSystems)),
                    .send(.dashboard(.diagramPage(.fetchSelectedSystem)))
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
        .ifLet(\.$destination, action: \.destination)
    }
}
