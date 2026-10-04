//
//  Dashboard.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Dashboard {
    @Reducer
    enum Destination {
        case entryForm(EntryForm)
    }

    @ObservableState
    struct State {
        var trends: TrendsFeature.State
        @Presents var destination: Destination.State?

        init(sections: Shared<[Logbook.Section]>) {
            self.trends = .init(sections: sections)
        }
    }
    
    enum Action {
        case onAppear
        case presentEntryForm(EntryForm.State?)
        case trends(TrendsFeature.Action)
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.trends, action: \.trends) {
            TrendsFeature()
        }
        Reduce { state, action in
            switch action {
            case .onAppear: ()

            case let .presentEntryForm(entryFormState):
                state.destination = .entryForm(entryFormState ?? EntryForm.State())

            case .destination(.presented(.entryForm(.cancel))):
                state.destination = nil
                
            case .destination(.presented(.entryForm(.saveDidFinish))):
                state.destination = nil

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
