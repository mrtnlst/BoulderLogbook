//
//  AppReducer.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import ComposableArchitecture

let appReducer = AnyReducer<AppState, AppAction, AppEnvironment>
    .combine(
        summaryReducer.pullback(
            state: \AppState.summaryState,
            action: /AppAction.summary,
            environment: {
                SummaryEnvironment(
                    mainQueue: $0.mainQueue,
                    fetch: $0.storageService.fetch,
                    delete: $0.storageService.delete(logbookEntry:),
                    fetchFilters: $0.storageService.fetchFilters
                )
            }
        ),
        formReducer.optional().pullback(
            state: \AppState.formState,
            action: /AppAction.form,
            environment: {
                FormEnvironment(
                    save: $0.storageService.save(logbookEntry:)
                )
            }
        ),
        AnyReducer {
            FilterSheet(mainQueue: $0.mainQueue, fetch: $0.storageService.fetch, save: $0.storageService.save)
        }
        .optional()
        .pullback(
            state: \.filterSheetState,
            action: /AppAction.filterSheet,
            environment: { $0 }
        ),
    Reducer { state, action, environment in
        switch action {
        case let .setIsPresentingForm(isPresenting):
            state.formState = isPresenting ? FormState() : nil
            state.isPresentingForm = isPresenting
            return .none
            
        case let .setIsPresentingFilter(isPresenting):
            state.filterSheetState = isPresenting ? FilterSheet.State() : nil
            state.isPresentingFilter = isPresenting
            return .none
            
        case let .setPath(path):
            state.path = path
            return .none
            
        case .form(.cancel):
            return Effect(value: .setIsPresentingForm(false))
            
        case .form(.save):
            return .merge(
                Effect(value: .setIsPresentingForm(false)),
                Effect(value: .summary(.fetch))
            )
            
        case .form(_):
            return .none
            
        case .summary(.summarySectionAction(id: _, action: .entryAction(id: _, action: .delete(_)))):
            state.path = []
            return .none
            
        case let .summary(.summarySectionAction(id: _, action: .edit(entry))),
             let .summary(.summarySectionAction(id: _, action: .entryAction(id: _, action: .edit(entry)))):
            state.path = []
            state.formState = FormState(entry: entry, isNewEntry: false)
            state.isPresentingForm = true
            return .none
            
        case .summary(.presentFilters):
            return Effect(value: .setIsPresentingFilter(true))
            
        case .summary(_):
            return .none
        
        case .filterSheet(.filter(_, .setIsOn(_))):
            return Effect(value: .summary(.fetchFilters))
            
        case .filterSheet(_):
            return .none
        }
   }
)
