//
//  GradeSystemFormView.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import SwiftUI
import ComposableArchitecture

struct GradeSystemFormView: View {
    let store: StoreOf<GradeSystemForm>
    @FocusState private var focusedField: UUID?
    private let nameTextFieldId = UUID()
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                Form {
                    Section {
                        nameTextField()
                    }
                    Section(
                        content: { gradesInputFields() },
                        header: { Text("Drag to set difficulty order") }
                    )
                    Section {
                        actionButtons()
                            .listRowInsets(.zero)
                    }
                }
                .navigationTitle("New Grade System")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        toolbarButtons()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if viewStore.grades.count > 1 {
                            EditButton()
                        }
                    }
                }
            }
        }
        .interactiveDismissDisabled()
        .scrollDismissesKeyboard(.interactively)
    }
}

extension GradeSystemFormView {
    @ViewBuilder func nameTextField() -> some View {
        WithViewStore(store) { viewStore in
            TextField("Name", text: viewStore.binding(\.$name))
                .focused($focusedField, equals: nameTextFieldId)
        }
    }
    
    @ViewBuilder func gradesInputFields() -> some View {
        WithViewStore(store) { viewStore in
            ForEach(viewStore.binding(\.$grades)) { $grade in
                HStack {
                    ColorPicker(
                        selection: $grade.color,
                        supportsOpacity: false,
                        label: {}
                    )
                    .labelsHidden()
                    TextField(
                        grade.color.description.capitalized,
                        text: $grade.name
                    )
                    .focused($focusedField, equals: grade.id)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                }
            }
            .onMove { viewStore.send(.moveGrade($0, $1)) }
            .onDelete { viewStore.send(.deleteGrade($0)) }
        }
    }
    
    @ViewBuilder func actionButtons() -> some View {
        WithViewStore(store) { viewStore in
            RectangularButton(
                title: "Save",
                action: {
                    focusedField = nil
                    viewStore.send(.save)
                }
            )
            .foregroundColor(.green)
            RectangularButton(
                title: "Cancel",
                action: {
                    focusedField = nil
                    viewStore.send(.cancel)
                }
            )
            .foregroundColor(.red)
        }
    }
    
    @ViewBuilder func toolbarButtons() -> some View {
        WithViewStore(store) { viewStore in
            Button(
                action: { focusNextTextField(for: viewStore.grades, reversed: true) },
                label: { Image(systemName: "chevron.up.circle")}
            )
            .disabled(focusedField == nameTextFieldId)
            Button(
                action: { focusNextTextField(for: viewStore.grades) },
                label: { Image(systemName: "chevron.down.circle") }
            )
            Spacer()
            Button(
                action: {
                    viewStore.send(.addGrade)
                    focusNextTextField(for: viewStore.grades)
                },
                label: { Image(systemName: "plus.circle") }
            )
            .disabled(focusedField == nameTextFieldId)
        }
    }
    
    func focusNextTextField(for grades: [GradeSystem.Grade], reversed: Bool = false) {
        let summand: Int = reversed ? -1 : 1
        if let index = grades.firstIndex(where: { $0.id == focusedField }) {
            if let nextGrade = grades[safe: index + summand] {
                focusedField = nextGrade.id
            } else if index + summand >= grades.count, grades.count > 0 {
                focusedField = grades[0].id
            } else if index + summand < 0, grades.count > 0 {
                focusedField = grades[grades.count - 1].id
            }
        } else if focusedField == nameTextFieldId, grades.count > 0 {
            focusedField = grades[0].id
        }
    }
}

struct GradeSystemFormView_Previews: PreviewProvider {
    static var previews: some View {
        GradeSystemFormView(
            store: Store(
                initialState: GradeSystemForm.State(),
                reducer: GradeSystemForm()
            )
        )
    }
}
