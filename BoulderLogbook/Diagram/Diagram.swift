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
        var entries: [Logbook.Entry] = []
        var filters: [BoulderGrade] = BoulderGrade.allCases
        var selectedSegment: Segment = .week
        
        init(entries: [Logbook.Entry] = []) {
            self.entries = entries
        }
    }
    
    enum Action: Equatable {
        case didSelectSegment(Diagram.State.Segment)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .didSelectSegment(segment):
            state.selectedSegment = segment
            return .none
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
            return [.week]
        } else if entries.count <= Segment.month.tag {
            return [.week, .month]
        } else {
            return [.week, .month, .all]
        }
    }
    
    var maximumValue: Int {
        let values = chartSections.map { $0.count }
        return values.max() ?? 0
    }
    
    var hasXAxisValueLabel: Bool {
        selectedSegment == .week
    }
}

extension Diagram.State {
    var chartSections: [Entry] {
        return entries.prefix(selectedSegment.tag).reduce(into: []) { partialResult, entry in
            partialResult.append(
                contentsOf: BoulderGrade.allCases.compactMap { grade in
                    guard filters.contains(grade) else {
                        return nil
                    }
                    let count = entry.numberOfGrades(for: grade)
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
    }
}

extension Diagram.State {
    struct Entry: Identifiable {
        let id: UUID = UUID()
        var grade: BoulderGrade
        var date: String
        var count: Int
    }
}
