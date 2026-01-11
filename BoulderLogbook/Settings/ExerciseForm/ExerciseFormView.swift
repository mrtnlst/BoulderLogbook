//
//  ExerciseFormView.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: ExerciseFormFeature.self)
struct ExerciseFormView: View {
    @Bindable var store: StoreOf<ExerciseFormFeature>
    @FocusState var focused: Bool?

    var body: some View {
        NavigationStack {
            PlainList {
                PlainSection {
                    nameTextField()
                }
                PlainSection {
                    symbolPicker()
                }
            }
            .navigationTitle("New Exercise")
            .toolbarTitleDisplayMode(.inline)
            .toolbar { toolbarContent() }
            .onAppear { focused = true }
        }
        .interactiveDismissDisabled()
        .scrollDismissesKeyboard(.interactively)
        .preferredColorScheme(.dark)
    }
}

extension ExerciseFormView {
    @MainActor
    func nameTextField() -> some View {
        HStack {
            Label("Name", systemImage: "character.cursor.ibeam")
            TextField(
                "",
                text: $store.name.sending(\.didEditName),
                prompt: Text("Enter Name")
                    .foregroundStyle(.secondaryText)
            )
            .multilineTextAlignment(.trailing)
            .submitLabel(.done)
            .autocorrectionDisabled()
            .focused($focused, equals: true)
        }
    }
    
    func symbolPicker() -> some View {
        Picker(selection: $store.symbol.sending(\.didSelectSymbol)) {
            Text("None")
                .tag(String?.none)
            ForEach(ExerciseSymbol.allCases, id: \.self) {
                Label($0.description, systemImage: $0.rawValue)
                    .tag($0.rawValue)
            }
        } label: {
            Label("Symbol", systemImage: ExerciseSymbol.traditionalStrength.rawValue)
        }
        .pickerStyle(.menu)
    }

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
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
                .disabled(store.name.isEmpty)
            } else {
                Button {
                    send(.save)
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
    ExerciseFormView(
        store: Store(initialState: ExerciseFormFeature.State()) {
            ExerciseFormFeature()
        }
    )
}
