//
//  EntryFormView.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import SwiftUI
import ComposableArchitecture

struct EntryFormView: View {
    @Bindable var store: StoreOf<EntryForm>

    var body: some View {
        NavigationStack {
            PlainList {
                PlainSection { gradeSystems() }
                PlainSection { tops() }
                PlainSection { datePicker() }
                PlainSection { notes() }
            }
            .navigationTitle(store.isEditing ? "Update Entry" : "New Entry")
            .toolbarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .onAppear { store.send(.onAppear) }
            .toolbar { toolbarContent() }
        }
        .preferredColorScheme(.dark)
    }
}

extension EntryFormView {
    @MainActor
    func gradeSystems() -> some View {
        Picker(selection: $store.selectedSystemId) {
            Text("None")
                .tag(UUID?.none)
            ForEach(store.gradeSystems) {
                Text($0.name)
                    .tag($0.id as UUID?)
            }
        } label: {
            Label(
                title: { Text("Grade System") },
                icon: { Image(systemName: "square.fill.text.grid.1x2") }
            )
            .foregroundStyle(.primaryText)
        }
        .pickerStyle(.menu)
        .disabled(store.isEditing)
    }
    
    @ViewBuilder 
    func tops() -> some View {
        ForEach(store.selectedSystem?.grades ?? []) { grade in
            DisclosureGroup {
                stepper(
                    title: "Attempt: \(store.attempts.count(for: grade))",
                    icon: "figure.fall",
                    color: grade.color,
                    value: $store[attempts: grade]
                )
                stepper(
                    title: "Flash: \(store.flashs.count(for: grade))",
                    icon: "bolt.fill",
                    color: grade.color,
                    value: $store[flashs: grade]
                )
                stepper(
                    title: "Onsight: \(store.onsights.count(for: grade))",
                    icon: "eye.fill",
                    color: grade.color,
                    value: $store[onsights: grade]
                )
            } label: {
                Stepper(
                    value: $store[tops: grade],
                    label: {
                        Label {
                            let count = store.tops.count(for: grade)
                            + store.flashs.count(for: grade)
                            + store.onsights.count(for: grade)
                            VStack(alignment: .leading) {
                                Text("Tops: \(count)")
                                    .foregroundStyle(.primaryText)
                                Text(grade.name)
                                    .foregroundStyle(.tertiaryText)
                                    .font(.caption)
                            }
                        } icon: {
                            Image(systemName: "triangle.fill")
                                .foregroundStyle(grade.color)
                        }
                    }
                )
            }
        }
    }
    
    func stepper(
        title: String,
        icon: String,
        color: Color,
        value: Binding<Int>
    ) -> some View {
        Stepper(
            value: value,
            label: {
                Label {
                    Text(title)
                        .foregroundStyle(.primaryText)
                } icon: {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                }
            }
        )
    }

    @MainActor 
    func datePicker() -> some View {
        DatePicker(
            selection: $store.date,
            in: ...Date(),
            displayedComponents: [.hourAndMinute, .date]
        ) {
            Label(
                title: { Text("Date") },
                icon: { Image(systemName: "calendar") }
            )
            .foregroundStyle(.primaryText)
        }
    }

    @ViewBuilder
    func notes() -> some View {
        let isNotEdited = store.notes == store.notesPlaceHolder
        ZStack(alignment: .topLeading) {
            if store.notes.isEmpty {
                Text(store.notesPlaceHolder)
                    .foregroundStyle(.tertiary)
                    .padding(EdgeInsets(top: 7, leading: 5, bottom: 0, trailing: 0))
            }
            TextEditor(text: $store.notes)
                .textEditorStyle(.plain)
                .foregroundStyle(isNotEdited ? .secondaryText : .primaryText)
                .onTapGesture {
                    if isNotEdited {
                        store.send(.binding(.set(\.notes, "")))
                    }
                }
        }
    }
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if #available(iOS 26, *) {
                Button(role: .close) {
                    store.send(.cancel)
                }
            } else {
                Button {
                    store.send(.cancel)
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if #available(iOS 26, *) {
                Button(role: .confirm) {
                    store.send(.save)
                }
                .tint(.araPrimary)
                .disabled(store.isSaveButtonDisabled)
            } else {
                Button {
                    store.send(.save)
                } label: {
                    Label("Save", systemImage: "checkmark")
                }
                .tint(.araPrimary)
                .disabled(store.isSaveButtonDisabled)
            }
        }
    }
}

/// Had to move this outside ``EntryForm`` otherwise it didn't compile.
extension StoreOf<EntryForm> {
    subscript(attempts grade: Grade) -> Int {
        get { self.attempts.count(for: grade) }
        set {
            self.send(.attemptStepperChanged(newValue, grade))
        }
    }
    subscript(flashs grade: Grade) -> Int {
        get { self.flashs.count(for: grade) }
        set {
            self.send(.flashStepperChanged(newValue, grade))
        }
    }
    subscript(onsights grade: Grade) -> Int {
        get { self.onsights.count(for: grade) }
        set {
            self.send(.onsightStepperChanged(newValue, grade))
        }
    }
    subscript(tops grade: Grade) -> Int {
        get { self.tops.count }
        set {
            self.send(.topStepperChanged(newValue, grade))
        }
    }
}

#Preview {
    Text("Text")
        .sheet(isPresented: .constant(true)) {
            EntryFormView(
                store: Store(
                    initialState: EntryForm.State()
                ) {
                    EntryForm()
                        .dependency(GradeSystemClient.previewValue)
                }
            )
        }
}
