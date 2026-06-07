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
                PlainList {
                    sessionCount
                    mostCommonWeekday
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
            ForEach(InsightsFeature.TimeSegment.allCases, id: \.self) { segment in
                Text(segment.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    var sessionCount: some View {
        switch store.sessionCountViewState {
        case .loading:
            LoadingIndicator()
                .frame(maxWidth: .infinity)
        case let .idle(message):
            Label {
                Text(message)
            } icon: {
                Image(systemName: "sum")
                    .foregroundStyle(Color.araLightRed)
            }
        case let .error(message):
            EmptyMessageView(message: message)
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    var mostCommonWeekday: some View {
        switch store.mostCommonWeekdayViewState {
        case .loading:
            LoadingIndicator()
                .frame(maxWidth: .infinity)
        case let .idle(message):
            Label {
                Text(message)
            } icon: {
                Image(systemName: "calendar.day.timeline.left")
                    .foregroundStyle(Color.araLightBlue)
            }

        case .error:
            EmptyView()
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
                    [
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
