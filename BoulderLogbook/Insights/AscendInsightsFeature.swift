//
//  AscendInsightsFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AscendInsightsFeature {
    @ObservableState
    struct State {
        internal var timeSegment: TimeSegment
        internal var entries: [Logbook.Section.Entry] = []
        internal var gradeSystem: GradeSystem?
        var gradeWithMostAscendsInsight: String?
    }
    
    enum Action {
        case timeSegmentDidChange(TimeSegment)
        case receiveValues(GradeSystem?, [Logbook.Section.Entry])
    }

    @Dependency(\.calendar) var calendar
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .timeSegmentDidChange(newValue):
                state.timeSegment = newValue
            
            case let .receiveValues(gradeSystem, entries):
                state.entries = entries
                state.gradeSystem = gradeSystem
            }
            updateGradeWithMostAscends(in: &state)
            return .none
        }
    }
}

extension AscendInsightsFeature {
    func updateGradeWithMostAscends(
        in state: inout AscendInsightsFeature.State
    ) {
        guard let gradeSystem = state.gradeSystem else {
            state.gradeWithMostAscendsInsight = "No grade system available!"
            return
        }
        let startDate = if let calendarComponent = state.timeSegment.calendarComponent { calendar.dateInterval(of: calendarComponent, for: .now)?.start ?? .now
        } else {
            Date.distantPast
        }

        let filteredEntries = state.entries.filter({ $0.gradeSystem == gradeSystem.id })
        let tops = filteredEntries
            .filter { $0.date > startDate }
            .reduce(into: [], { $0.append(contentsOf: $1.tops) })
            .successful()
        
        let ascendsPerGrade = gradeSystem.grades.reduce(into: [Grade: Int]()) { partialResult, grade in
            partialResult[grade] = tops.count(for: grade)
        }
        if let element = ascendsPerGrade.max(by: { $0.value < $1.value }) {
            let time = switch state.timeSegment {
            case .all: "of all time"
            case .year: "in the last year"
            case .month: "in the last month"
            }
            state.gradeWithMostAscendsInsight = "\(element.key.name) is your most ascended grade \(time) with \(element.value) ascends."
        } else {
            state.gradeWithMostAscendsInsight = "No entries available!"
        }
    }
}
