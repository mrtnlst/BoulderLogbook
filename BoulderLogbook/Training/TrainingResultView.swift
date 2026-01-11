//
//  TrainingResultView.swift
//  BoulderLogbook
//
//  Created by Martin List on 11.01.26.
//

import SwiftUI
import ComposableArchitecture

struct TrainingResultView: View {
    @Bindable var store: StoreOf<TrainingResultFeature>

    var body: some View {
        VStack(spacing: 20) {
            Picker(
                "Choose the kind of result you want to log",
                selection: $store.selectedSegment.sending(\.didSelectSegment)
            ) {
                ForEach(TrainingResultFeature.Segment.allCases, id: \.self) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            
            switch store.selectedSegment {
            case .repititions:
                repititionStepper
            case .duration:
                timePicker
            }
        }
    }
}

private extension TrainingResultView {
    var repititionStepper: some View {
        Stepper(
            value: $store.repititions.sending(\.didChangeStepper),
            label: {
                Label("Repititions: \(store.repititions)", systemImage: "plus.arrow.trianglehead.counterclockwise")
                    .foregroundStyle(.primaryText)
            }
        )
    }
    
    var timePicker: some View {
        Label("Coming soon …", systemImage: "megaphone")
            .foregroundStyle(.primaryText)
    }
}

#Preview {
    NavigationStack {
        PlainList {
            PlainSection {
                TrainingResultView(
                    store: Store(initialState: TrainingResultFeature.State()) {
                        TrainingResultFeature()
                    }
                )
            }
        }
        .navigationTitle("Results")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
    .preferredColorScheme(.dark)
}
