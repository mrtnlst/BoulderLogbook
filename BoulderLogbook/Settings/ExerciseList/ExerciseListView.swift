//
//  ExerciseListView.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: ExerciseListFeature.self)
struct ExerciseListView: View {
    @Bindable var store: StoreOf<ExerciseListFeature>

    var body: some View {
        PlainList {
            ForEach(store.exercises) { exercise in
                Label(exercise.name, systemImage: exercise.symbol)
                    .swipeActions {
                        swipeButtons(exercise: exercise)
                    }
            }
        }
        .navigationTitle("Exercises")
        .toolbarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .onAppear { send(.onAppear) }
        .alert(
            $store.scope(
                state: \.destination?.confirmationDialog,
                action: \.destination.confirmationDialog
            )
        )
        .sheet(
            item: $store.scope(
                state: \.destination?.exerciseForm,
                action: \.destination.exerciseForm
            )
        ) {
            ExerciseFormView(store: $0)
        }
    }
}

private extension ExerciseListView {    
    @ViewBuilder
    func swipeButtons(exercise: Exercise) -> some View {
        Button {
            send(.setExerciseToDelete(exercise))
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.araError)
        Button {
            send(.edit(exercise.id))
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.araWarning)
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                send(.presentExerciseForm)
            } label: {
                Label("Add grade system", systemImage: "plus")
            }
        }
    }
}

#Preview {
    NavigationView {
        ExerciseListView(
            store: Store(
                initialState: ExerciseListFeature.State(
                    exercises: [
                        .deadHang,
                        .sitUp,
                        .pullUp
                    ]
                )
            ) {
                ExerciseListFeature()
            }
        )
    }
}
