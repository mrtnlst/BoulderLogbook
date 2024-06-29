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
    @Reducer(state: .equatable)
    enum Destination {
        case gradeSystemList(GradeSystemList)
        case appIconList(AppIconList)
        case about(About)
    }
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case setGradeSystemListNavigation
        case setAppIconListNavigation
        case setAboutNavigation
        case deleteEntriesDidFinish(TaskResult<EntryClientResponse>)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(LogbookEntryClient.self) var entryClient
    
    var body: some Reducer<State, Action> {
       Reduce { state, action in
            switch action {
            case let .destination(.presented(.gradeSystemList(.delete(id)))):
                return .merge(
                    .run { send in
                        await send(
                            .deleteEntriesDidFinish(
                                TaskResult {
                                    await entryClient.deleteEntries(id)
                                    return .finished
                                }
                            )
                        )
                    }
                )
                
            case .setGradeSystemListNavigation:
                state.destination = .gradeSystemList(.init())
   
            case .setAppIconListNavigation:
                state.destination = .appIconList(.init())

            case .setAboutNavigation:
                state.destination = .about(.init())
                
            default: ()
            }
            return .none
        }
       .ifLet(\.$destination, action: \.destination)
    }
}
