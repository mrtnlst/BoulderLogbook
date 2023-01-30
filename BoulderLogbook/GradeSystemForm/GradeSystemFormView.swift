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
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                Form {
                    Section {
                        nameTextField()
                    }
                    Section(
                        content: { gradesInput() },
                        header: { Text("Drag to set difficulty order") }
                    )
                    Section {
                        buttons()
                            .listRowInsets(.zero)
                    }
                }
                .navigationTitle(
                    viewStore.name.isEmpty
                    ? "New Grade System"
                    : viewStore.name
                )
                .toolbar {
                    if viewStore.grades.count > 1 {
                        EditButton()
                    }
                }
            }
        }
    }
}

extension GradeSystemFormView {
    @ViewBuilder func nameTextField() -> some View {
        WithViewStore(store) { viewStore in
            TextField("Name", text: viewStore.binding(\.$name))
        }
    }
    
    @ViewBuilder func gradesInput() -> some View {
        WithViewStore(store) { viewStore in
            List {
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
                        .id(grade.id)
                        .focused($focusedField, equals: grade.id)
                    }
                    .onSubmit {
                        guard let index = viewStore.grades.firstIndex(of: grade) else {
                            return
                        }
                        if let nextGrade = viewStore.grades[safe: index + 1] {
                            focusedField = nextGrade.id
                        } else {
                            viewStore.send(.addGrade)
                            focusedField = viewStore.grades[safe: index + 1]?.id
                        }
                    }
                }
                .onMove { viewStore.send(.moveGrade($0, $1)) }
                .onDelete { viewStore.send(.deleteGrade($0)) }
            }
        }
    }
    
    @ViewBuilder func buttons() -> some View {
        WithViewStore(store) { viewStore in
            RectangularButton(
                title: "Save",
                action: { viewStore.send(.save) }
            )
            .foregroundColor(.green)
            
            RectangularButton(
                title: "Cancel",
                action: { viewStore.send(.cancel) }
            )
            .foregroundColor(.red)
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
