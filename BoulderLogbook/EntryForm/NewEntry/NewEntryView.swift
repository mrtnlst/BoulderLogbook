//
//  NewEntryView.swift
//  BoulderLogbook
//
//  Created by Martin List on 07.10.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: NewEntryFeature.self)
struct NewEntryView: View {
    @Bindable var store: StoreOf<NewEntryFeature>

    var body: some View {
        NavigationStack {
            PlainList {
                PlainSection { gradeSystems() }
                PlainSection { datePicker() }
                PlainSection { gradeSelectionEntry }
                PlainSection { notes() }
            }
            .navigationTitle(store.isEditing ? "Update Entry" : "New Entry")
            .toolbarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .toolbar { toolbarContent }
            .task { send(.task) }
        }
        .preferredColorScheme(.dark)
    }
}

private extension NewEntryView {
    func gradeSystems() -> some View {
        Picker(selection: $store.selectedSystem.sending(\.setSelectedSystem)) {
            Text("None")
                .tag(GradeSystem?.none)
            ForEach(store.gradeSystems) {
                Text($0.name)
                    .tag($0)
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

    var gradeSelectionEntry: some View {
        VStack {
            totalAscends
            gradeSelectionView
            topSelectionView
            keypadView
        }
        .disabled(store.selectedSystem == nil)
    }
    
    var totalAscends: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("\(store.selectionCountText): \(store.selectionCount)")
                .foregroundStyle(.primaryText)
                .font(.title2)
            Spacer()
            Text("\(store.totalAscends) total")
        }
        .foregroundStyle(.primaryText)
    }

    @ViewBuilder
    var gradeSelectionView: some View {
        HorizontalSelectionView(
            store: store.scope(
                \.gradeSelection,
                 action: \.gradeSelection
            ),
            prefix: "Grade ",
            borderColor: .araPrimary
        )
    }
    
    var topSelectionView: some View {
        HorizontalSelectionView(
            store: store.scope(
                \.ascendTypeSelection,
                 action: \.ascendTypeSelection
            ),
            prefix: nil,
            borderColor: .araAccent
        )
    }
    
    var keypadView: some View {
        KeypadView(
            store: store.scope(
                \.keypad,
                 action: \.keypad
            )
        )
    }
    
    func datePicker() -> some View {
        DatePicker(
            selection: $store.date.sending(\.setDate),
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
                    .foregroundStyle(.secondaryText)
                    .padding(EdgeInsets(top: 7, leading: 5, bottom: 0, trailing: 0))
            }
            TextEditor(text: $store.notes.sending(\.setNotes))
                .textEditorStyle(.plain)
                .foregroundStyle(isNotEdited ? .secondaryText : .primaryText)
                .onTapGesture {
                    if isNotEdited {
                        store.send(.setNotes(""))
                    }
                }
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if #available(iOS 26, *) {
                Button(role: .close) {
                    send(.cancel)
                }
            } else {
                Button {
                    send(.cancel)
                } label: {
                    Label("Close", systemImage: "xmark")
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if #available(iOS 26, *) {
                Button(role: .confirm) {
                    send(.save)
                }
                .disabled(store.isSaveButtonDisabled)
            } else {
                Button {
                    send(.save)
                } label: {
                    Label("Save", systemImage: "checkmark")
                }
                .disabled(store.isSaveButtonDisabled)
                .buttonStyle(.borderedProminent)
                .tint(.araAccent)
            }
        }
    }
}

#Preview {
    @Shared(.fileStorage(.defaultGradeSystem))
    var gradeSystem: GradeSystem = .mandala2
    let _ = $gradeSystem.withLock { $0 = .mandala2 }

    ZStack {
        Color.araBackground
            .ignoresSafeArea()
        NewEntryView(
            store: Store(
                initialState: NewEntryFeature.State(
                    selectedSystem: .mandala2,
                    gradeSystems: [.mandala, .mandala2]
                )
            ) {
                NewEntryFeature()
            }
        )
    }
}
