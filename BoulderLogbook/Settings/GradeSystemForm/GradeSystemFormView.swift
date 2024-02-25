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
    @FocusState var focusedField: GradeSystemForm.State.Field?

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                .bind(viewStore.$focusedField, to: $focusedField)
                .navigationTitle("New Grade System")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if viewStore.grades.count > 1 {
                            EditButton()
                        }
                    }
                }
                .sheet(
                    store: store.scope(
                        state: \.$colorPicker,
                        action: \.colorPicker
                    )
                ) {
                    ColorPickerSheet(store: $0)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
        }
        .interactiveDismissDisabled()
        .scrollDismissesKeyboard(.interactively)
        .preferredColorScheme(.dark)
    }
}

extension GradeSystemFormView {
    @MainActor func nameTextField() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TextField(
                "",
                text: viewStore.$name,
                prompt: Text("Name")
                    .foregroundStyle(.secondaryText)
            )
            .focused($focusedField, equals: .name)
            .submitLabel(.continue)
            .onSubmit {
                viewStore.send(.onSubmitNameField)
            }
            .autocorrectionDisabled()
        }
    }
    
    @MainActor func gradesInputFields() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ForEach(viewStore.$grades) { $grade in
                HStack {
                    Button {
                        viewStore.send(.presentColorPicker(grade))
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
                        viewStore.send(.addGrade)
                    }
                    .autocorrectionDisabled()
                }
            }
            .onMove { viewStore.send(.moveGrade($0, $1)) }
            .onDelete { viewStore.send(.deleteGrade($0)) }
        }
    }
    
    func buttons() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            RectangularButton.save {
                focusedField = nil
                viewStore.send(.save)
            }
            .disabled(viewStore.name.isEmpty)
            RectangularButton.cancel {
                focusedField = nil
                viewStore.send(.cancel)
            }
        }
    }
}

struct GradeSystemFormView_Previews: PreviewProvider {
    static var previews: some View {
        GradeSystemFormView(
            store: Store(
                initialState: GradeSystemForm.State()
            ) {
                GradeSystemForm()
            }
        )
    }
}
