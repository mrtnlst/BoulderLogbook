//
//  GradeSystemForm.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import Foundation
import ComposableArchitecture

struct GradeSystemForm: ReducerProtocol {
    struct State: Equatable {
        var id: UUID
        @BindableState var name: String
        @BindableState var grades: [GradeSystem.Grade]
        
        init(
            id: UUID = UUID(),
            name: String = "",
            grades: [GradeSystem.Grade] = [GradeSystem.Grade()]
        ) {
            self.id = id
            self.name = name
            self.grades = grades
        }
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case cancel
        case save
        case addGrade
        case moveGrade(IndexSet, Int)
        case deleteGrade(IndexSet)
    }
    
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .cancel:
                return .none
                
            case .save:
                guard !state.name.isEmpty else {
                    return .none
                }
                state.grades.removeAll(where: { $0.name.isEmpty })
                let gradeSystem = GradeSystem(
                    id: state.id,
                    name: state.name,
                    grades: state.grades
                )
                return .fireAndForget {
                    gradeSystemClient.saveSystem(gradeSystem)
                }
            
            case .addGrade:
                var nextDifficulty: Int = 0
                if let lastDifficulty = state.grades.last?.difficulty {
                    nextDifficulty = lastDifficulty + 1
                }
                state.grades.append(
                    GradeSystem.Grade(difficulty: nextDifficulty)
                )
                return .none
            
            case let .moveGrade(from, to):
                var grades = state.grades
                grades.move(fromOffsets: from, toOffset: to)
                for (index, _) in grades.enumerated() {
                    grades[index].difficulty = index
                }
                state.grades = grades
                return .none
                
            case let .deleteGrade(from):
                var grades = state.grades
                grades.remove(atOffsets: from)
                for (index, _) in grades.enumerated() {
                    grades[index].difficulty = index
                }
                if grades.isEmpty {
                    grades.append(GradeSystem.Grade())
                }
                state.grades = grades
                return .none
            }
        }
    }
}
