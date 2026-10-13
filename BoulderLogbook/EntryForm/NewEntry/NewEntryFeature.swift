//
//  NewEntryFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 07.10.26.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NewEntryFeature {
    @ObservableState
    struct State {
        var gradeSelection: HorizontalSelectionFeature<Grade>.State
        var ascendTypeSelection: HorizontalSelectionFeature<AscendType>.State
        var keypad = KeypadFeature.State()
        let notesPlaceHolder = "Additional notes …"

        let id: UUID
        var date: Date
        var notes: String
        let gradeSystems: [GradeSystem]
        var selectedSystem: GradeSystem?
        var isEditing: Bool
        var topsPerGrade: [Grade: [Top]] = [:]
        var selectionCountText: String = "Ascends"
        var selectionCount: String = "0"

        var totalAscends: Int {
            guard let grade = gradeSelection.selectedElement,
                  let ascendType = ascendTypeSelection.selectedElement,
                  let tops = topsPerGrade[grade]
            else {
                return 0
            }
            return tops.filter(for: ascendType).count
        }
        
        var isSaveButtonDisabled: Bool {
            selectedSystem == nil || topsPerGrade.isEmpty
        }
        
        init(
            id: UUID = UUID(),
            date: Date = .now,
            notes: String? = nil,
            selectedSystem: GradeSystem?,
            gradeSystems: [GradeSystem],
            isEditing: Bool = false
        ) {
            self.id = id
            self.date = date
            self.notes = notes ?? ""
            self.selectedSystem = selectedSystem
            self.gradeSystems = gradeSystems
            self.isEditing = isEditing
            self.ascendTypeSelection = .init(elements: AscendType.allCases)
            self.gradeSelection = .init(elements: selectedSystem?.grades ?? [])
        }
    }

    enum Action: ViewAction {
        enum EntryClientResponse {
            case finished
        }
        enum View {
            case task
            case save
            case cancel
        }
        case gradeSelection(HorizontalSelectionFeature<Grade>.Action)
        case ascendTypeSelection(HorizontalSelectionFeature<AscendType>.Action)
        case keypad(KeypadFeature.Action)
        case saveDidFinish(Result<EntryClientResponse, Never>)
        case setSelectedSystem(GradeSystem?)
        case setDate(Date)
        case setNotes(String)
        case view(View)
    }
    @Dependency(\.logbookEntryClient) var entryClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Scope(\.ascendTypeSelection, action: \.ascendTypeSelection) {
            HorizontalSelectionFeature()
        }
        Scope(\.gradeSelection, action: \.gradeSelection) {
            HorizontalSelectionFeature()
        }
        Scope(\.keypad, action: \.keypad) {
            KeypadFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(.task): ()
            case let .keypad(.delegate(.didUpdateValue(value))):
                state.selectionCount = value
                
            case let .keypad(.delegate(.didPressSaveKey(value))):
                guard let grade = state.gradeSelection.selectedElement,
                      let ascendType = state.ascendTypeSelection.selectedElement,
                      let intValue = Int(value)
                else {
                    return .none
                }
                guard intValue != 0 else {
                    state.topsPerGrade[grade]?.removeAll()
                    return .none
                }
                let savedTops = state.topsPerGrade[grade] ?? []
                let newTops = (1...intValue).map { _ in
                    Top(grade: grade.id, ascendType: ascendType)
                }
                state.topsPerGrade[grade] = savedTops + newTops

            case .keypad(.delegate(.didPressClearKey)):
                guard let grade = state.gradeSelection.selectedElement else {
                    return .none
                }
                state.topsPerGrade[grade] = nil

            case let .ascendTypeSelection(.delegate(.didSelectElement(element))):
                state.selectionCountText = element == .attempt ? "Attempts" : "Ascends"
            
            case .view(.cancel):
                return .run { _ in
                    await dismiss()
                }

            case .view(.save):
                guard let gradeSystem = state.selectedSystem else {
                    return .none
                }
                let entry = Logbook.Section.Entry(
                    id: state.id,
                    date: state.date,
                    notes: state.notes.isEmpty ? nil : state.notes,
                    tops: state.topsPerGrade.flatMap { $0.value },
                    gradeSystem: gradeSystem.id
                )
                return .run { [isEditing = state.isEditing] send in
                    await send(
                        .saveDidFinish(
                            Result {
                                if isEditing {
                                    await entryClient.updateEntry(entry)
                                } else {
                                    await entryClient.saveEntry(entry)
                                }
                                return .finished
                            }
                        )
                    )
                }
                
            case .saveDidFinish(.success):
                return .run { _ in
                    await dismiss()
                }
                
            case let .setSelectedSystem(gradeSystem):
                state.selectedSystem = gradeSystem
                state.gradeSelection = .init(elements: gradeSystem?.grades ?? [])
                state.topsPerGrade.removeAll()

            case let .setDate(date):
                state.date = date

            case let .setNotes(notes):
                state.notes = notes

            default: ()
            }
            return .none
        }
    }
}
