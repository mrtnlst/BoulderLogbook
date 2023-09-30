//
//  GradeSystemForm.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import Foundation
import ComposableArchitecture

struct GradeSystemForm: Reducer {
    struct State: Equatable {
        let id: UUID
        @BindingState var name: String
        @BindingState var grades: [GradeSystem.Grade]
        
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
        case save
        case addGrade
        case moveGrade(IndexSet, Int)
        case deleteGrade(IndexSet)
        case saveDidFinish(TaskResult<ClientResponse>)
        case cancel
        case binding(BindingAction<State>)

        enum ClientResponse { case finished }
    }
    
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {                
            case .save:
                guard !state.name.isEmpty else {
                    return .none
                }
                let gradeSystem = GradeSystem(
                    id: state.id,
                    name: state.name,
                    grades: state.grades
                )
                return .run { send in
                    await send(
                        .saveDidFinish(
                            TaskResult {
                                gradeSystemClient.saveSystem(gradeSystem)
                                return .finished
                            }
                        )
                    )
                }
                
            case .addGrade:
                var nextDifficulty: Int = 0
                if let lastDifficulty = state.grades.last?.difficulty {
                    nextDifficulty = lastDifficulty + 1
                }
                state.grades.append(
                    GradeSystem.Grade(difficulty: nextDifficulty)
                )
            
            case let .moveGrade(from, to):
                var grades = state.grades
                grades.move(fromOffsets: from, toOffset: to)
                for (index, _) in grades.enumerated() {
                    grades[index].difficulty = index
                }
                state.grades = grades
                
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
                
            default: ()
            }
            return .none
        }
    }
}
