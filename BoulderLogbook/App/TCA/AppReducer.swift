//
//  AppReducer.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import ComposableArchitecture

let appReducer = Reducer<AppState, AppAction, AppEnvironment>
    .combine(
        summaryReducer.pullback(
            state: \AppState.summaryState,
            action: /AppAction.summary,
            environment: {
                SummaryEnvironment(
                    mainQueue: $0.mainQueue,
                    fetch: $0.storageService.fetch,
                    delete: $0.storageService.delete(logbookEntry:)
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
    Reducer { state, action, _ in
        switch action {
        case .setIsPresentingForm(true):
            state.formState = FormState()
            state.isPresentingForm = true
            return .none
        
        case .setIsPresentingForm(false):
            state.isPresentingForm = false
            state.formState = nil
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
            
        case .summary(.summaryDetailAction(id: _, action: .didSelectBackButton)):
            state.path = []
            return .none
            
        case let .summary(.edit(entry)):
            state.formState = FormState(logbookEntry: entry)
            state.isPresentingForm = true
            return .none
            
        case .summary(_):
            return .none
        }
   }
)
