//
//  Dashboard.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Dashboard {
    @Reducer
    enum Destination {
        case newEntry(NewEntryFeature)
    }

    @ObservableState
    struct State {
        var trends: TrendsFeature.State
        @Presents var destination: Destination.State?
        @Shared var gradeSystems: [GradeSystem]
        @Shared(.fileStorage(.defaultGradeSystem)) var defaultGradeSystem: GradeSystem?

        init(
            sections: Shared<[Logbook.Section]>,
            gradeSystems: Shared<[GradeSystem]>
        ) {
            self.trends = .init(sections: sections)
            self._gradeSystems = gradeSystems
        }
    }
    
    enum Action: ViewAction {
        enum View {
            case presentNewEntry
        }
        case trends(TrendsFeature.Action)
        case view(View)
        case destination(PresentationAction<Destination.Action>)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.trends, action: \.trends) {
            TrendsFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(.presentNewEntry):
                state.destination = .newEntry(
                    .init(
                        selectedSystem: state.defaultGradeSystem,
                        gradeSystems: state.gradeSystems
                    )
                )

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
