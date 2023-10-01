//
//  TopCountDiagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.02.23.
//

import Foundation
import ComposableArchitecture

struct TopCountDiagram: Reducer {
    struct State: Equatable {
        var viewState: ViewState<[Top], String> = .loading
        var gradeSystem: GradeSystem?
        @BindingState var selectedSegment: Segment = .week
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case fetchData
        case receiveData([Logbook.Section.Entry], GradeSystem?)
        case didPressEmptyView
    }
    
    enum Segment: String, Equatable, CaseIterable {
        case week = "Past 7"
        case month = "Past 30"
        case all = "All-time"
        
        var value: Int? {
            switch self {
            case .week: return 7
            case .month: return 30
            case .all: return nil
            }
        }
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case let .receiveData(entries, gradeSystem):
                state.gradeSystem = gradeSystem
                guard let gradeSystem = gradeSystem else {
                    state.viewState = .error("Create or select grade system in Settings!")
                    return .none
                }
                let filteredEntries = entries.filter({ $0.gradeSystem == gradeSystem.id })
                
                var tops: [Top] = []
                if let value = state.selectedSegment.value {
                    tops = filteredEntries
                        .sorted(by: { $0.date > $1.date })
                        .prefix(value)
                        .reduce(into: [], { $0.append(contentsOf: $1.tops) })
                        .successful()
                } else {
                 tops = filteredEntries
                        .reduce(into: [], { $0.append(contentsOf: $1.tops) })
                        .successful()
                }
                if tops.isEmpty {
                    state.viewState = .error("No entries available!")
                } else {
                    state.viewState = .idle(tops)
                }
                
            case .binding(\.$selectedSegment):
                return .send(.fetchData)
                
            default: ()
            }
            return .none
        }
    }
}
