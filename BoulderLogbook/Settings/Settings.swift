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
    struct Destination {
        enum State: Equatable {
            case gradeSystemList(GradeSystemList.State)
            case appIconList(AppIconList.State)
            case about(About.State)
        }
        
        enum Action: Equatable {
            case gradeSystemList(GradeSystemList.Action)
            case appIconList(AppIconList.Action)
            case about(About.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.gradeSystemList, action: \.gradeSystemList) {
                GradeSystemList()
            }
            Scope(state: \.appIconList, action: \.appIconList) {
                AppIconList()
            }
            Scope(state: \.about, action: \.about) {
                About()
            }
        }
    }
    
    struct State: Equatable {
        @PresentationState var destination: Destination.State?
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case setGradeSystemListNavigation
        case setAppIconListNavigation
        case setAboutNavigation
        case deleteEntriesDidFinish(TaskResult<EntryClientResponse>)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.logbookEntryClient) var entryClient
    
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
       .ifLet(\.$destination, action: \.destination) {
         Destination()
       }
    }
}
