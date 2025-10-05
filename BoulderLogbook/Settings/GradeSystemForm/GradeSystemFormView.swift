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
            }
            .bind($store.focusedField, to: $focusedField)
            .navigationTitle("New Grade System")
            .toolbarTitleDisplayMode(.inline)
            .toolbar { toolbarContent() }
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
                
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(.secondaryText)
            }
        }
        .onMove { store.send(.moveGrade($0, $1)) }
        .onDelete { store.send(.deleteGrade($0)) }
    }

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if #available(iOS 26, *) {
                Button(role: .close) {
                    focusedField = nil
                    store.send(.cancel)
                }
            } else {
                Button {
                    focusedField = nil
                    store.send(.cancel)
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if #available(iOS 26, *) {
                Button(role: .confirm) {
                    focusedField = nil
                    store.send(.save)
                }
                .disabled(store.name.isEmpty)
            } else {
                Button {
                    focusedField = nil
                    store.send(.save)
                } label: {
                    Label("Save", systemImage: "checkmark")
                }
                .disabled(store.name.isEmpty)
                .buttonStyle(.borderedProminent)
                .tint(.araAccent)
            }
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
