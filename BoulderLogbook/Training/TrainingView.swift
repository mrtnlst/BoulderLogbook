//
//  TrainingView.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.10.25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: TrainingFeature.self)
struct TrainingView: View {
    @Bindable var store: StoreOf<TrainingFeature>

    var body: some View {
        NavigationStack {
            PlainList {
                ForEach(store.trainings) {
                    trainingRow(for: $0)
                }
            }
            .navigationTitle("Training")
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
                    state: \.destination?.trainingForm,
                    action: \.destination.trainingForm
                )
            ) {
                TrainingFormView(store: $0)
            }
        }
    }
}

private extension TrainingView {
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                send(.presentTrainingForm)
            } label: {
                Label("Add training", systemImage: "plus")
            }
        }
    }
    
    var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }
    
    func trainingRow(for training: Training) -> some View {
        HStack {
            Label {
                VStack(alignment: .leading) {
                    Text(training.exercise.name)
                    Text(training.date, format: .dateTime.year().month().day().hour().minute())
                        .font(.footnote)
                        .foregroundStyle(.secondaryText)
                        .padding(.leading, 2)
                }
            } icon: {
                Image(systemName: training.exercise.symbol)
            }
            Spacer()
            switch training.result {
            case let .repititions(value):
                Text("\(value)")
            case let .duration(value):
                Text(formatter.string(from: value) ?? "")
                    
            }
        }
        .swipeActions {
            swipeButtons(training: training)
        }
    }
    
    @ViewBuilder
    func swipeButtons(training: Training) -> some View {
        Button {
            send(.setTrainingToDelete(training))
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.araError)
        Button {
            send(.edit(training.id))
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.araWarning)
    }
}

#Preview {
    TrainingView(
        store: Store(
            initialState: TrainingFeature.State()
        ) {
            TrainingFeature()
        }
    )
    .preferredColorScheme(.dark)
}
