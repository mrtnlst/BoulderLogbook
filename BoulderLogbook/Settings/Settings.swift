//
//  Settings.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Settings {
    @Reducer
    enum Destination {
        case gradeSystemList(GradeSystemList)
        case appIconList(AppIconList)
        case about(About)
    }
    
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        @Shared var gradeSystems: [GradeSystem]
        
        init(gradeSystems: Shared<[GradeSystem]>) {
            self._gradeSystems = gradeSystems
        }
    }
    
    enum Action {
        enum Delegate {
            case fetchGradeSystems
        }
        case destination(PresentationAction<Destination.Action>)
        case setGradeSystemListNavigation
        case setAppIconListNavigation
        case setAboutNavigation
        case delegate(Delegate)
    }
    
    @Dependency(\.logbookEntryClient) var entryClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .setGradeSystemListNavigation:
                state.destination = .gradeSystemList(
                    .init(gradeSystems: state.$gradeSystems)
                )
                
            case .setAppIconListNavigation:
                state.destination = .appIconList(.init())
                
            case .setAboutNavigation:
                state.destination = .about(.init())
                
            case .destination(.presented(.gradeSystemList(.delegate(.fetchGradeSystems)))):
                return .send(.delegate(.fetchGradeSystems))

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
