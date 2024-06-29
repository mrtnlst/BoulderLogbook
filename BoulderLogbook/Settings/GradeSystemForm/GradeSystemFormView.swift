//
//  GradeSystemFormView.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//

import SwiftUI
import ComposableArchitecture

struct GradeSystemFormView: View {
    @Bindable var store: StoreOf<GradeSystemForm>
    @FocusState var focusedField: GradeSystemForm.State.Field?

    var body: some View {
        NavigationStack {
            PlainList {
                PlainSection {
                    nameTextField()
                }
                PlainSection {
                    gradesInputFields()
                } header: {
                    Text("Drag to set difficulty order")
                }
                PlainSection {
                    buttons()
                }
            }
            .bind($store.focusedField, to: $focusedField)
            .navigationTitle("New Grade System")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if store.grades.count > 1 {
                        EditButton()
                    }
                }
            }
            .sheet(
                item: $store.scope(
                    state: \.colorPicker,
                    action: \.colorPicker
                )
            ) {
                ColorPickerSheet(store: $0)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
        .interactiveDismissDisabled()
        .scrollDismissesKeyboard(.interactively)
        .preferredColorScheme(.dark)
    }
}

extension GradeSystemFormView {
    @MainActor 
    func nameTextField() -> some View {
        TextField(
            "",
            text: $store.name,
            prompt: Text("Name")
                .foregroundStyle(.secondaryText)
        )
        .focused($focusedField, equals: .name)
        .submitLabel(.continue)
        .onSubmit {
            store.send(.onSubmitNameField)
        }
        .autocorrectionDisabled()
    }
    
    @MainActor
    func gradesInputFields() -> some View {
        ForEach($store.grades) { $grade in
            HStack {
                Button {
                    store.send(.presentColorPicker(grade))
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundStyle(grade.color)
                        .font(.title)
                }

                TextField(
                    "",
                    text: $grade.name,
                    prompt: Text("e.g. 'Blue', 'A' or '1'")
                        .foregroundStyle(.secondaryText)
                )
                .focused($focusedField, equals: .newGrade(grade.id))
                .submitLabel(.continue)
                .onSubmit {
                    store.send(.addGrade)
                }
                .autocorrectionDisabled()
            }
        }
        .onMove { store.send(.moveGrade($0, $1)) }
        .onDelete { store.send(.deleteGrade($0)) }
    }
    
    @ViewBuilder
    func buttons() -> some View {
        RectangularButton.save {
            focusedField = nil
            store.send(.save)
        }
        .disabled(store.name.isEmpty)

        RectangularButton.cancel {
            focusedField = nil
            store.send(.cancel)
        }
    }
}

#Preview {
    GradeSystemFormView(
        store: Store(
            initialState: GradeSystemForm.State()
        ) {
            GradeSystemForm()
        }
    )
}
