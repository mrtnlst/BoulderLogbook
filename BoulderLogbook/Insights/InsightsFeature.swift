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
    @Reducer
    enum Destination {
        case sessionsDiagram(SessionDiagram)
        case topCountDiagram(TopCountDiagram)
    }

    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        @Shared var selectedSegment: TimeSegment
        @Shared var entries: [Logbook.Section.Entry]
        @Shared(.fileStorage(.defaultGradeSystem)) var gradeSystem: GradeSystem?
        
        var sessionInsights: SessionInsightsFeature.State
        var ascendInsights: AscendInsightsFeature.State
        
        init() {
            self._selectedSegment = Shared(value: .month)
            self._entries = Shared(value: [])
            self.sessionInsights = .init(
                timeSegment: self._selectedSegment,
                entries: self._entries
            )
            self.ascendInsights = .init(
                timeSegment: self._selectedSegment,
                entries: self._entries,
                gradeSystem: self._gradeSystem
            )
        }
    }

    enum Action: ViewAction {
        enum View {
            case task
        }
        case fetchEntries
        case receiveEntries(Result<[Logbook.Section.Entry], Never>)
        case setTimeSegment(TimeSegment)
        case sessionInsights(SessionInsightsFeature.Action)
        case ascendInsights(AscendInsightsFeature.Action)
        case destination(PresentationAction<Destination.Action>)
        case view(View)
    }
    
    @Dependency(\.logbookEntryClient) var entryClient

    var body: some ReducerOf<Self> {
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
                
            case .sessionInsights(.view(.didTapSessionCountButton)):
                state.destination = .sessionsDiagram(
                    SessionDiagram.State(entries: state.$entries)
                )
                
            case .ascendInsights(.view(.didTapMostAscendsButton)):
                state.destination = .topCountDiagram(
                    TopCountDiagram.State(
                        entries: state.$entries,
                        gradeSystem: state.$gradeSystem
                    )
                )
                
            case let .receiveEntries(.success(entries)):
                state.$entries.withLock { $0 = entries }

            case let .setTimeSegment(segment):
                state.$selectedSegment.withLock {
                    $0 = segment
                }
                
            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
