//
//  TopCountDiagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.02.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TopCountDiagram {
    @ObservableState
    struct State: Equatable {
        @Shared var sections: [Logbook.Section]
        @Shared var gradeSystem: GradeSystem?
        var selectedSegment: Segment = .week
        var viewState: ViewState<[Top], String> = .loading
        
        init(
            sections: Shared<[Logbook.Section]>,
            gradeSystem: Shared<GradeSystem?>
        ) {
            self._sections = sections
            self._gradeSystem = gradeSystem
        }
    }
    
    enum Action: Equatable, ViewAction {
        enum View {
            case task
            case didPressEmptyView
        }
        case setSegment(Segment)
        case view(View)
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
        Reduce { state, action in
            switch action {
            case .view(.task):
                guard let gradeSystem = state.gradeSystem else {
                    state.viewState = .error("Create or select a Grade System for your Diagrams!")
                    return .none
                }
                let filteredEntries = state.sections.entries.filter {
                    $0.gradeSystem == gradeSystem.id
                }
                
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
                
            case let .setSegment(segment):
                state.selectedSegment = segment
                return .send(.view(.task))
                
            default: ()
            }
            return .none
        }
    }
}
