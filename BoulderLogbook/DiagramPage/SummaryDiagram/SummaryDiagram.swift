//
//  SummaryDiagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.06.23.
//

import Foundation
import ComposableArchitecture

struct SummaryDiagram: ReducerProtocol {
    struct State: Equatable {
        let hasWeekFilter: Bool
        var viewState: ViewState<[Model], String> = .loading
    }
    
    enum Action: Equatable {
        case receiveData([Logbook.Section.Entry], GradeSystem?)
    }
    
    struct Model: Identifiable, Equatable {
        let id: UUID = UUID()
        let gradeSystem: GradeSystem
        let grade: GradeSystem.Grade
        let tops: Int
        let attempts: Int
        let flash: Int
        let onsight: Int
        var maxValue: Int { [tops, attempts, flash, onsight].reduce(0, +) }
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .receiveData(entries, gradeSystem):
            guard !entries.isEmpty else {
                state.viewState = .empty("No entries available!")
                return .none
            }
            
            guard let gradeSystem = gradeSystem else {
                state.viewState = .empty("Choose grade system in Settings!")
                return .none
            }
            let filteredTops = entries
                .filter({ $0.gradeSystem == gradeSystem.id })
                .sorted(by: { $0.date > $1.date })
            // Only use entries from the last 7 days.
                .prefix(
                    while: { entry in
                        if state.hasWeekFilter {
                            return entry.date > Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? .now
                        }
                        return true
                    }
                )
                .reduce(into: [], { $0.append(contentsOf: $1.tops) })
            guard !filteredTops.isEmpty else {
                state.viewState = .empty("No entries available!")
                return .none
            }
            let models = gradeSystem.grades.compactMap { grade in
                let topsOfGrade = filteredTops.filter({ $0.grade == grade.id })
                return Model(
                    gradeSystem: gradeSystem,
                    grade: grade,
                    tops: topsOfGrade.normal().count,
                    attempts: topsOfGrade.filter({ $0.isAttempt }).count,
                    flash: topsOfGrade.filter({ $0.wasFlash }).count,
                    onsight: topsOfGrade.filter({ $0.wasOnsight }).count
                )
            }
            state.viewState = .idle(models)
            
        default: ()
        }
        return .none
    }
}
