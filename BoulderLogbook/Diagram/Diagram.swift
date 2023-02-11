//
//  Diagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct Diagram: ReducerProtocol {
    struct State: Equatable {
        struct Entry: Identifiable, Equatable {
            let id: UUID = UUID()
            var grade: GradeSystem.Grade
            var date: String
            var count: Int
        }
        
//        var filters: [LegacyBoulderGrade] = LegacyBoulderGrade.allCases
        
        var entries: [Logbook.Section.Entry]
        var gradeSystems: [GradeSystem] = []
        var selectedSystem: GradeSystem?
        @BindingState var selectedSegment: Segment = .week
        
        init(
            entries: [Logbook.Section.Entry] = [],
            gradeSystems: [GradeSystem] = []
        ) {
            self.entries = entries
            self.gradeSystems = gradeSystems
        }
        
        var chartEntries: [Entry] {
            let chartEntries = entries
                .sorted(by: { $0.date > $1.date })
                .prefix(selectedSegment.tag)
                .reduce(into: [Entry]()) { partialResult, entry in
                    guard entry.gradeSystem == selectedSystem?.id,
                          let selectedSystem = selectedSystem
                    else {
                        return
                    }
                    partialResult.append(
                        contentsOf: selectedSystem.grades.compactMap { grade in
//                        guard filters.contains(grade) else {
//                            return nil
//                        }
                            let count = entry.tops.count(for: grade)
                            if count > 0 {
                                return Entry(
                                    grade: grade,
                                    date: entry.date.dayMonthDateString ?? "",
                                    count: count
                                )
                            }
                            return nil
                        }
                    )
            }
            return chartEntries
        }
    }
    
    enum Action: Equatable, BindableAction {
        case onAppear
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case presentFilters
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.gradeSystemClient) var client
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
            
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .task { .fetchSelectedSystem }
                
            case .fetchSelectedSystem:
                return .task {
                    await .receiveSelectedSystem(
                        TaskResult {
                            client.fetchSelectedSystem()
                        }
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                if let system = state.gradeSystems.first(where: { $0.id == selected }) {
                    state.selectedSystem = system
                }
                return .none
                
            default:
                return .none
            }
        }
    }
}

extension Diagram.State {
    enum Segment: String, Equatable {
        case week = "7 Days"
        case month = "30 Days"
        case all = "All-time"
        
        var tag: Int {
            switch self {
            case .week:
                return 7
            case .month:
                return 30
            case .all:
                return 100
            }
        }
    }
}

extension Diagram.State {
    var availableSegments: [Segment] {
        if entries.count <= Segment.week.tag {
            return []
        } else if entries.count <= Segment.month.tag {
            return [.week, .month]
        } else {
            return [.week, .month, .all]
        }
    }
    
    var maximumValue: Int {
        let values = chartEntries.map { $0.count }
        return values.max() ?? 0
    }
    
    var hasXAxisValueLabel: Bool {
        selectedSegment == .week
    }
}
