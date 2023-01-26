//
//  AppReducer.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import ComposableArchitecture

let appReducer = AnyReducer<AppState, AppAction, AppEnvironment>.combine(
    AnyReducer {
        EntryForm(save: $0.storageService.save(logbookEntry:))
    }.optional().pullback(
        state: \.entryFormState,
        action: /AppAction.entryForm,
        environment: { $0 }
    ),
    AnyReducer {
        Dashboard(
            mainQueue: $0.mainQueue,
            fetch: $0.storageService.fetch,
            delete: $0.storageService.delete(logbookEntry:),
            fetchFilters: $0.storageService.fetchFilters
        )
    }.pullback(
        state: \.dashboardState,
        action: /AppAction.dashboard,
        environment: { $0 }
    ),
    AnyReducer {
        FilterSheet(
            mainQueue: $0.mainQueue,
            fetch: $0.storageService.fetch,
            save: $0.storageService.save
        )
    }.optional().pullback(
        state: \.filterSheetState,
        action: /AppAction.filterSheet,
        environment: { $0 }
    ),
    Reducer { state, action, environment in
        switch action {
        case let .setIsPresentingForm(isPresenting):
            state.entryFormState = isPresenting ? EntryForm.State() : nil
            state.isPresentingForm = isPresenting
            return .none
            
        case let .setIsPresentingFilter(isPresenting):
            state.filterSheetState = isPresenting ? FilterSheet.State() : nil
            state.isPresentingFilter = isPresenting
            return .none
            
        case let .setPath(path):
            state.path = path
            return .none
            
        case .entryForm(.cancel):
            return Effect(value: .setIsPresentingForm(false))
            
        case .entryForm(.save):
            return .merge(
                Effect(value: .setIsPresentingForm(false)),
                Effect(value: .dashboard(.fetch))
            )
            
        case .entryForm(_):
            return .none
            
        case .dashboard(.dashboardSection(id: _, action: .entryDetail(id: _, action: .delete(_)))):
            state.path = []
            return .none
            
        case let .dashboard(.dashboardSection(id: _, action: .edit(entry))),
            let .dashboard(.dashboardSection(id: _, action: .entryDetail(id: _, action: .edit(entry)))):
            state.path = []
            state.entryFormState = EntryForm.State(entry: entry, isNewEntry: false)
            state.isPresentingForm = true
            return .none
            
        case .dashboard(.presentFilters):
            return Effect(value: .setIsPresentingFilter(true))
            
        case .dashboard(_):
            return .none
            
        case .filterSheet(.filter(_, .setIsOn(_))):
            return Effect(value: .dashboard(.fetchFilters))
            
        case .filterSheet(_):
            return .none
        }
    }
)
