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
        var entries: [Logbook.Section.Entry]
        var gradeSystems: [GradeSystem] = []
        var filters: [Filter] = []
        var selectedSystem: GradeSystem?
        var chartEntries: [Entry] = []
        var isFetching: Bool = true // TODO: Add dedicated View State
        @BindingState var selectedSegment: Segment = .week
        
        init(
            entries: [Logbook.Section.Entry] = [],
            gradeSystems: [GradeSystem] = [],
            filters: [Filter] = []
        ) {
            self.entries = entries
            self.gradeSystems = gradeSystems
            self.filters = filters
        }
    }
    
    enum Action: Equatable, BindableAction {
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case fetchFilters
        case receiveFilters(TaskResult<[Filter]?>)
        case presentFilters
        case setChartEntries
        case binding(BindingAction<State>)
    }
    @Dependency(\.filterClient) var filterClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
            
        Reduce { state, action in
            switch action {
            case .fetchSelectedSystem:
                state.isFetching = true
                return .task {
                    await .receiveSelectedSystem(
                        TaskResult {
                            filterClient.fetchFilterSystem()
                        }
                    )
                }
                
            case let .receiveSelectedSystem(.success(.some(selected))):
                if let system = state.gradeSystems.first(where: { $0.id == selected }) {
                    state.selectedSystem = system
                }
                return .task { .fetchFilters }
            
            case .receiveSelectedSystem(.success(.none)):
                state.selectedSystem = nil
                state.filters = []
                state.chartEntries = []
                state.isFetching = false
                return .none
                
            case .fetchFilters:
                state.isFetching = true
                return .task {
                    await .receiveFilters(
                        TaskResult { filterClient.fetchFilters() }
                    )
                }
                
            case let .receiveFilters(.success(filters)):
                var availableFilters: [Filter] = []
                if let system = state.selectedSystem,
                   let filters = filters {
                    filters.forEach { filter in
                        if system.grades.contains(where: { $0.id == filter.id }) {
                            availableFilters.append(filter)
                        }
                    }
                }
                state.filters = availableFilters
                return .task { .setChartEntries }
                
            case .setChartEntries:
                state.isFetching = false
                state.chartEntries = state.entries
                    .sorted(by: { $0.date > $1.date })
                    .prefix(state.selectedSegment.tag)
                    .reduce(into: [Diagram.State.Entry]()) { partialResult, entry in
                        guard let selectedSystem = state.selectedSystem,
                              entry.gradeSystem == selectedSystem.id
                        else {
                            return
                        }
                        partialResult.append(
                            contentsOf: selectedSystem.grades.compactMap { grade in
                                if !state.filters.isEmpty,
                                   let filter = state.filters.first(where: { $0.id == grade.id }),
                                   !filter.isOn {
                                    return nil
                                }
                                let count = entry.tops.count(for: grade)
                                if count > 0 {
                                    return Diagram.State.Entry(
                                        grade: grade,
                                        date: entry.date.dayMonthDateString ?? "",
                                        count: count
                                    )
                                }
                                return nil
                            }
                        )
                    }
                return .none
                
            case .binding(\.$selectedSegment):
                return .task { .setChartEntries }
                
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
        guard selectedSystem != nil, !isFetching else {
            return []
        }
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
