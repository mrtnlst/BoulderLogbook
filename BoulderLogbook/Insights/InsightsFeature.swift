//
//  InsightsFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.06.26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct InsightsFeature {
    @ObservableState
    struct State {
        var selectedSegment: TimeSegment
        var isLoading: Bool = true
        var sessionInsights: SessionInsightsFeature.State
        var ascendInsights: AscendInsightsFeature.State
        internal var entries: [Logbook.Section.Entry] = []
        internal var gradeSystem: GradeSystem?
        
        init() {
            let initalTimeSegment = TimeSegment.month
            selectedSegment = initalTimeSegment
            sessionInsights = .init(timeSegment: initalTimeSegment)
            ascendInsights = .init(timeSegment: initalTimeSegment)
        }
    }

    enum Action: BindableAction, ViewAction {
        enum View {
            case task
        }
        case fetchEntries
        case receiveEntries(Result<[Logbook.Section.Entry], Never>)
        case receiveGradeSystem(GradeSystem?)
        case sessionInsights(SessionInsightsFeature.Action)
        case ascendInsights(AscendInsightsFeature.Action)
        case binding(BindingAction<State>)
        case view(View)
    }
    
    @Dependency(\.calendar) var calendar
    @Dependency(\.logbookEntryClient) var entryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient

    var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.sessionInsights, action: \.sessionInsights) {
            SessionInsightsFeature()
        }
        Scope(state: \.ascendInsights, action: \.ascendInsights) {
            AscendInsightsFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(.task):
                return .run { send in
                    await send(
                        .receiveEntries(
                            Result {
                                await entryClient.fetchEntries()
                            }
                        )
                    )
                }

            case let .receiveEntries(.success(entries)):
                state.entries = entries
                return .merge(
                    .run { send in
                        await send(.receiveGradeSystem(await gradeSystemClient.fetchSelectedSystem()))
                    },
                    .run { send in
                        await send(.sessionInsights(.entriesDidChange(entries)))
                    }
                )
            case let .receiveGradeSystem(gradeSystem):
                state.gradeSystem = gradeSystem
                state.isLoading = false
                return .run { [entries = state.entries] send in
                    await send(.ascendInsights(.receiveValues(gradeSystem, entries)))
                }

            case .binding(\.selectedSegment):
                return .merge(
                    .run { [segment = state.selectedSegment] send in
                        await send(.sessionInsights(.timeSegmentDidChange(segment)))
                    },
                    .run { [segment = state.selectedSegment] send in
                        await send(.ascendInsights(.timeSegmentDidChange(segment)))
                    }
                )

            default: ()
            }
            return .none
        }
    }
}
