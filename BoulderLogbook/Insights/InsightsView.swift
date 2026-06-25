//
//  InsightsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.06.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: InsightsFeature.self)
struct InsightsView: View {
    @Bindable var store: StoreOf<InsightsFeature>

    var body: some View {
        NavigationStack {
            VStack {
                picker

                if store.isLoading {
                    LoadingIndicator()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    listView
                }
            }
            .background(Color.araBackground)
            .navigationTitle("Insights")
            .toolbarTitleDisplayMode(.inlineLarge)
            .task { send(.task) }
        }
        .preferredColorScheme(.dark)
    }
}

private extension InsightsView {
    var picker: some View {
        Picker(
            "Select time frame",
            selection: $store.selectedSegment
        ) {
            ForEach(TimeSegment.allCases, id: \.self) { segment in
                Text(segment.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 10)
    }

    var listView: some View {
        PlainList {
            PlainSection("Sessions") {
                SessionInsightsView(
                    store: store.scope(
                        state: \.sessionInsights,
                        action: \.sessionInsights
                    )
                )
            }
            PlainSection("Ascends") {
                AscendInsightsView(
                    store: store.scope(
                        state: \.ascendInsights,
                        action: \.ascendInsights
                    )
                )
            }
        }
    }
}

#Preview {
    InsightsView(
        store: Store(
            initialState: .init(),
            reducer: {
                InsightsFeature()
            },
            withDependencies: {
                let aMonthAgo: TimeInterval = -2678400
                let aYearAgo: TimeInterval = -31536000
                $0.logbookEntryClient.fetchEntries = {
                    do {
                        try await Task.sleep(for: .seconds(1))
                    } catch {
                        
                    }
                    return [
                        .init(date: .now, gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now, gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now.addingTimeInterval(aMonthAgo), gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now.addingTimeInterval(aMonthAgo), gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now.addingTimeInterval(aMonthAgo), gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now.addingTimeInterval(aYearAgo), gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now.addingTimeInterval(aYearAgo), gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now.addingTimeInterval(aYearAgo), gradeSystem: GradeSystem.mandala.id),
                        .init(date: .now.addingTimeInterval(aYearAgo), gradeSystem: GradeSystem.mandala.id),
                    ] + [Logbook.Section.Entry].samples
                }
            }
        )
    )
}
