//
//  AscendInsightsFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.26.
//

import SwiftUI
import ComposableArchitecture

private extension String {
    static let storedKey = "selected-ascended-grade-id"
}

@Reducer
struct AscendInsightsFeature {
    private enum EffectId {
        case taskEffect
    }

    @ObservableState
    struct State {
        @Shared internal var timeSegment: TimeSegment
        @Shared internal var entries: [Logbook.Section.Entry]
        @Shared internal var gradeSystem: GradeSystem?
        @Shared(.appStorage(.storedKey)) internal var storedGradeId: UUID?
        
        var mostAscends: InsightModel = .mostAscends()
        var selectedAscends: InsightModel = .selectedAscends()
        var selectedAscendedGrade: Grade?

        init(
            timeSegment: Shared<TimeSegment>,
            entries: Shared<[Logbook.Section.Entry]>,
            gradeSystem: Shared<GradeSystem?>
        ) {
            self._timeSegment = timeSegment
            self._entries = entries
            self._gradeSystem = gradeSystem
        }
    }
    
    enum Action: ViewAction {
        enum View {
            case task
        }
        case setSelectedGrade(Grade?)
        case didUpdateSharedState
        case view(View)
    }
    @Dependency(\.calendar) var calendar
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.task):
                return .merge(
                    .publisher {
                        state.$timeSegment.publisher.map { _ in
                            Action.didUpdateSharedState
                        }
                    },
                    .publisher {
                        state.$entries.publisher.map { _ in
                            Action.didUpdateSharedState
                        }
                    },
                    .publisher {
                        state.$gradeSystem.publisher.map { _ in
                            Action.didUpdateSharedState
                        }
                    }
                )
                .cancellable(id: EffectId.taskEffect, cancelInFlight: true)

            case let .setSelectedGrade(grade):
                updateStoredGradeId(in: &state, with: grade?.id)
                updateSelectedAscendedGrade(in: &state)

            case .didUpdateSharedState:
                updateGradeWithMostAscends(in: &state)
                updateSelectedAscendedGrade(in: &state)
            }

            return .none
        }
    }
}

extension AscendInsightsFeature {
   func updateGradeWithMostAscends(
        in state: inout AscendInsightsFeature.State
    ) {
        guard let gradeSystem = state.gradeSystem else {
            state.mostAscends = .mostAscends(insight: "No grade system available!")
            return
        }
        let segment = state.timeSegment
        let startDate = if let calendarComponent = segment.calendarComponent { calendar.dateInterval(of: calendarComponent, for: .now)?.start ?? .now
        } else {
            Date.distantPast
        }

        let filteredEntries = state.entries.filter {
            $0.gradeSystem == gradeSystem.id
        }
        let tops = filteredEntries
            .filter { $0.date > startDate }
            .reduce(into: [], { $0.append(contentsOf: $1.tops) })
            .successful()
        
        let ascendsPerGrade = gradeSystem.grades.reduce(into: [Grade: Int]()) { partialResult, grade in
            partialResult[grade] = tops.count(for: grade)
        }
        if let element = ascendsPerGrade.max(by: { $0.value < $1.value }), element.value > 0 {
            state.mostAscends = .mostAscends(
                insight: "\(element.key.name) is your most ascended grade \(segment.description) with \(element.value) ascends."
            )
        } else {
            state.mostAscends = .mostAscends(insight: "No entries available!")
        }
    }
}


extension AscendInsightsFeature {
    func updateSelectedAscendedGrade(
        in state: inout AscendInsightsFeature.State
    ) {
        guard let gradeSystem = state.gradeSystem else {
            state.selectedAscends = .selectedAscends(insight: "No grade system available!")
            return
        }

        guard let grade = gradeSystem.grade(for: state.storedGradeId) else {
            updateStoredGradeId(in: &state, with: nil)
            state.selectedAscends = .selectedAscends(insight: "No grade selected!")
            return
        }
        state.selectedAscendedGrade = grade

        let segment = state.timeSegment
        let startDate = if let calendarComponent = segment.calendarComponent { calendar.dateInterval(of: calendarComponent, for: .now)?.start ?? .now
        } else {
            Date.distantPast
        }
        
        let filteredEntries = state.entries.filter({ $0.gradeSystem == gradeSystem.id })
        let tops = filteredEntries
            .filter { $0.date > startDate }
            .reduce(into: [], { $0.append(contentsOf: $1.tops) })
            .successful()
        let topsForGrade = tops.count(for: grade)
        let timeDescription = switch segment {
        case .all: "in total"
        default: segment.description
        }
        state.selectedAscends = .selectedAscends(
            insight: "You ascended \(grade.name) \(topsForGrade) times \(timeDescription)."
        )
    }
    
    func updateStoredGradeId(
        in state: inout AscendInsightsFeature.State,
        with newValue: UUID?
    ) {
        state.$storedGradeId.withLock {
            $0 = newValue
        }
    }
}
