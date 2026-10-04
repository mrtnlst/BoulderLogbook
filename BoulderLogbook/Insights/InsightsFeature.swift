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
        @Shared var sections: [Logbook.Section]
        @Shared(.fileStorage(.defaultGradeSystem)) var gradeSystem: GradeSystem?
        
        var sessionInsights: SessionInsightsFeature.State
        var ascendInsights: AscendInsightsFeature.State
        
        init(sections: Shared<[Logbook.Section]>) {
            self._selectedSegment = Shared(value: .month)
            self._sections = sections
            self.sessionInsights = .init(
                timeSegment: self._selectedSegment,
                sections: self._sections
            )
            self.ascendInsights = .init(
                timeSegment: self._selectedSegment,
                sections: self._sections,
                gradeSystem: self._gradeSystem
            )
        }
    }

    enum Action {
        case setTimeSegment(TimeSegment)
        case sessionInsights(SessionInsightsFeature.Action)
        case ascendInsights(AscendInsightsFeature.Action)
        case destination(PresentationAction<Destination.Action>)
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
            case .sessionInsights(.view(.didTapSessionCountButton)):
                state.destination = .sessionsDiagram(
                    SessionDiagram.State(sections: state.$sections)
                )
                
            case .ascendInsights(.view(.didTapMostAscendsButton)):
                state.destination = .topCountDiagram(
                    TopCountDiagram.State(
                        sections: state.$sections,
                        gradeSystem: state.$gradeSystem
                    )
                )

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
