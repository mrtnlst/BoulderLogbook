//
//  InsightsFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.06.26.
//

import ComposableArchitecture

@Reducer
struct InsightsFeature {
    enum TimeSegment: String, Hashable, CaseIterable {
        case month = "Month"
        case year = "Year"
        case all = "All time"
    }
    
    @ObservableState
    struct State {
        var selectedSegment: TimeSegment = .month
    }
    
    enum Action: BindableAction, ViewAction {
        enum View {
            case task
        }
        case binding(BindingAction<State>)
        case view(View)
    }
    
    @Dependency(\.logbookEntryClient) var entryClient
//    @Dependency(\.gradeSystemClient) var gradeSystemClient
        
    
    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .view(.task):
                ()
//            case .binding(\.selectedSegment):
            default: ()
            }
            return .none
        }
    }
}
