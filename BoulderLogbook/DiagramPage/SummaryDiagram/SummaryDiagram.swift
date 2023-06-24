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
        var entries: [Logbook.Section.Entry]
        var gradeSystem: GradeSystem?

        init(entries: [Logbook.Section.Entry] = [], gradeSystem: GradeSystem? = nil) {
            self.entries = entries
            self.gradeSystem = gradeSystem
        }
        
        var sections: [BarMarkSection] {
            let filteredTops = entries
                .filter({ $0.gradeSystem == gradeSystem?.id })
                .sorted(by: { $0.date > $1.date })
                // Only use entries from the last 7 days.
                .prefix(while: {
                    $0.date > Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? .now
                })
                .reduce(into: [], { $0.append(contentsOf: $1.tops) })
            guard !filteredTops.isEmpty else {
                return []
            }
            let sections = gradeSystem?.grades.compactMap { grade in
                let topsOfGrade = filteredTops.filter({ $0.grade == grade.id })
                return BarMarkSection(
                    grade: grade,
                    tops: topsOfGrade.normal().count,
                    attempts: topsOfGrade.filter({ $0.isAttempt }).count,
                    flash: topsOfGrade.filter({ $0.wasFlash }).count,
                    onsight: topsOfGrade.filter({ $0.wasOnsight }).count
                )
            }
            return sections ?? []
        }
    }
   
    struct BarMarkSection: Identifiable {
        let id: UUID = UUID()
        let grade: GradeSystem.Grade
        let tops: Int
        let attempts: Int
        let flash: Int
        let onsight: Int
        var maxValue: Int { [tops, attempts, flash, onsight].max() ?? 0 }
    }

    
    enum Action: Equatable {
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { _, _ in
            return .none
        }
    }
}
