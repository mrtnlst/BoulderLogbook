//
//  SummaryDiagram.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.06.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SummaryDiagram {
    @ObservableState
    struct State: Equatable {
        var viewState: ViewState<[Model], DataError> = .loading
        
        enum DataError {
            case noEntries
            case noGradeSystem
            
            var text: String {
                switch self {
                case .noEntries: return "No entries available!"
                case .noGradeSystem: return "Create or select a Grade System for your Diagrams!"
                }
            }
        }
    }
    
    enum Action: Equatable {
        case receiveData([Logbook.Section.Entry], GradeSystem?)
        case didPressEmptyView
    }
    
    struct Model: Identifiable, Equatable {
        let id: UUID = UUID()
        let gradeSystem: GradeSystem
        let grade: Grade
        let tops: Int
        let attempts: Int
        let flash: Int
        let onsight: Int
        var maxValue: Int { [tops, attempts, flash, onsight].reduce(0, +) }
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .receiveData(entries, gradeSystem):
            guard let gradeSystem = gradeSystem else {
                state.viewState = .error(.noGradeSystem)
                return .none
            }
            guard !entries.isEmpty else {
                state.viewState = .error(.noEntries)
                return .none
            }
            let filteredTops = entries
                .filter({ $0.gradeSystem == gradeSystem.id })
                .sorted(by: { $0.date > $1.date })
                .prefix(1)
                .reduce(into: [], { $0.append(contentsOf: $1.tops) })
            guard !filteredTops.isEmpty else {
                state.viewState = .error(.noEntries)
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
