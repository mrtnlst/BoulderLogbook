//
//  TopCountDiagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.02.23.
//

import Foundation
import ComposableArchitecture

struct TopCountDiagram: ReducerProtocol {
    struct State: Equatable {
        private let entries: [Logbook.Section.Entry]
        var gradeSystem: GradeSystem
        @BindingState var selectedSegment: Segment = .week

        init(entries: [Logbook.Section.Entry], gradeSystem: GradeSystem) {
            self.entries = entries
            self.gradeSystem = gradeSystem
        }
        
        var tops: [Top] {
            if let value = selectedSegment.value {
                return entries.sorted(by: { $0.date > $1.date })
                    .prefix(value)
                    .reduce(into: [], { $0.append(contentsOf: $1.tops) })
            }
            return entries.reduce(into: [], { $0.append(contentsOf: $1.tops) })
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    enum Segment: String, Equatable, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All-time"
        
        var value: Int? {
            switch self {
            case .week: return 7
            case .month: return 30
            case .all: return nil
            }
        }
    }
    
    
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
//            case .binding(\.$selectedSegment):
//
//                return .none
                
            default:
                return .none
            }
        }
    }
}
