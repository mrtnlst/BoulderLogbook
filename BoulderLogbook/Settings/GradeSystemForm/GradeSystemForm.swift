//
//  GradeSystemForm.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GradeSystemForm {
    struct State: Equatable {
        let id: UUID
        @BindingState var name: String
        @BindingState var grades: [Grade]
        @BindingState var focusedField: Field?
        @PresentationState var colorPicker: ColorPickerFeature.State?

        enum Field: Hashable {
            case name
            case newGrade(UUID)
        }

        init(
            id: UUID = UUID(),
            name: String = "",
            grades: [Grade] = [Grade()]
        ) {
            self.id = id
            self.name = name
            self.grades = grades
        }
    }
    
    enum Action: BindableAction, Equatable {
        case save
        case onSubmitNameField
        case addGrade
        case moveGrade(IndexSet, Int)
        case deleteGrade(IndexSet)
        case saveDidFinish(TaskResult<ClientResponse>)
        case cancel
        case presentColorPicker(Grade)
        case colorPicker(PresentationAction<ColorPickerFeature.Action>)
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
                var grades = state.grades
                grades.removeAll { $0.name.isEmpty }
                let gradeSystem = GradeSystem(
                    id: state.id,
                    name: state.name,
                    grades: grades
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

            case .onSubmitNameField:
                if let id = state.grades.first?.id {
                    state.focusedField = .newGrade(id)
                }

            case .addGrade:
                var nextDifficulty: Int = 0
                if let lastDifficulty = state.grades.last?.difficulty {
                    nextDifficulty = lastDifficulty + 1
                }
                let grade = Grade(difficulty: nextDifficulty)
                state.grades.append(grade)
                state.focusedField = .newGrade(grade.id)

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
                    grades.append(Grade())
                }
                state.grades = grades

            case let .presentColorPicker(grade):
                state.colorPicker = .init(grade: grade)

            case let .colorPicker(.presented(.didSelectColor(color, grade))):
                if let index = state.grades.firstIndex(where: { $0.id == grade.id }) {
                    state.grades[index].color = color
                }

            default: ()
            }
            return .none
        }
        .ifLet(\.$colorPicker, action: \.colorPicker) {
            ColorPickerFeature()
        }
    }
}
