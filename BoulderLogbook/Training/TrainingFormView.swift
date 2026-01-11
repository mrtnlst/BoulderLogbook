//
//  TrainingFormView.swift
//  BoulderLogbook
//
//  Created by Martin List on 18.10.25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: TrainingFormFeature.self)
struct TrainingFormView: View {
    @Bindable var store: StoreOf<TrainingFormFeature>

    var body: some View {
        NavigationStack {
            PlainList {
                PlainSection {
                    exercisePicker
                }
                PlainSection {
                    datePicker
                }
                PlainSection {
                    resultView
                }
            }
            .navigationTitle("New Training")
            .toolbarTitleDisplayMode(.inline)
            .toolbar { toolbarContent() }
            .onAppear { send(.onAppear) }
        }
        .interactiveDismissDisabled()
        .preferredColorScheme(.dark)
    }
}

private extension TrainingFormView {
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
                .disabled(store.exercise == nil)
            } else {
                Button {
                    send(.save)
                } label: {
                    Label("Save", systemImage: "checkmark")
                }
                .disabled(store.exercise == nil)
                .buttonStyle(.borderedProminent)
                .tint(.araAccent)
            }
        }
    }
    
    var exercisePicker: some View {
        Picker(selection: $store.exercise.sending(\.didSelectExercise)) {
            Text("None")
                .tag(Exercise?.none)
            ForEach(store.exercises) {
                Label($0.name, systemImage: $0.symbol)
                    .tag($0 as Exercise?)
            }
        } label: {
            Label(
                "Exercise",
                systemImage: ExerciseSymbol.traditionalStrength.rawValue
            )
        }
        .pickerStyle(.menu)
    }
    
    var datePicker: some View {
        DatePicker(
            selection: $store.date.sending(\.didSelectDate),
            in: ...Date(),
            displayedComponents: [.hourAndMinute, .date]
        ) {
            Label("Date", systemImage: "calendar")
                .foregroundStyle(.primaryText)
        }
    }

    @ViewBuilder
    var resultView: some View {
        TrainingResultView(
            store: store.scope(state: \.result, action: \.result)
        )
    }
}

#Preview {
    TrainingFormView(
        store: Store(
            initialState: TrainingFormFeature.State(
                id: UUID(),
                date: .now,
                exercise: .pullUp,
                result: .repititions(12)
            )
        ) {
            TrainingFormFeature()
        }
    )
}
