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
        @Shared var selectedSegment: TimeSegment
        @Shared internal var entries: [Logbook.Section.Entry]
        @Shared internal var gradeSystem: GradeSystem?
        var sessionInsights: SessionInsightsFeature.State
        var ascendInsights: AscendInsightsFeature.State
        
        init() {
            self._selectedSegment = Shared(value: .month)
            self._entries = Shared(value: [])
            self._gradeSystem = Shared(value: nil)
            sessionInsights = .init(
                timeSegment: self._selectedSegment,
                entries: self._entries
            )
            ascendInsights = .init(
                timeSegment: self._selectedSegment,
                entries: self._entries,
                gradeSystem: self._gradeSystem
            )
        }
    }

    enum Action: BindableAction, ViewAction {
        enum View {
            case task
        }
        case fetchEntries
        case receiveEntries(Result<[Logbook.Section.Entry], Never>)
        case fetchGradeSystem
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
                state.$entries.withLock { $0 = entries }
                return .run { send in
                    await send(.fetchGradeSystem)
                }
                
            case .fetchGradeSystem:
                return .run { send in
                    await send(.receiveGradeSystem(await gradeSystemClient.fetchSelectedSystem()))
                }

            case let .receiveGradeSystem(gradeSystem):
                state.$gradeSystem.withLock {
                    $0 = gradeSystem
                }

            default: ()
            }
            return .none
        }
    }
}
