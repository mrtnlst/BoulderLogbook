//
//  EntryView.swift
//  BoulderLogbook
//
//  Created by Martin List on 20.09.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: TrendsFeature.self)
struct TrendsView: View {
    let store: StoreOf<TrendsFeature>

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: 50, maximum: .infinity), alignment: .leading),
                GridItem(.flexible(minimum: 50, maximum: .infinity), alignment: .leading)
            ],
            spacing: 32
        ) {
            trendView(
                category: store.gymFrequency.category,
                text: store.gymFrequency.text,
                trend: store.gymFrequency.trend,
                colorStyle: .araAccent
            )
            trendView(
                category: store.ascendsOfGrade.category,
                text: store.ascendsOfGrade.text,
                trend: store.ascendsOfGrade.trend,
                colorStyle: .araPrimary
            )
        }
        .task { send(.task) }
    }
}

private extension TrendsView {
    func trendView(
        category: String,
        text: String,
        trend: Trend,
        colorStyle: Color
    ) -> some View {
        HStack {
            Image(systemName: trend.imageName)
                .symbolRenderingMode(.palette)
                .foregroundStyle(colorStyle, Color.araLightGray)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(category)
                    .font(.caption2)
                    .fontWeight(.semibold)
                Text(text)
                    .foregroundStyle(colorStyle)
            }
        }
    }
}

#Preview {
    PlainList {
        PlainSection {
            TrendsView(
                store: Store(
                    initialState: .init(
                        sections: Shared(
                            value: Logbook.Section.samples
                        )
                    )
                ) {
                    TrendsFeature()
                }
            )
        }
    }
}
