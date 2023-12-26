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
            case diagramConfiguration(DiagramConfiguration.State)
            case appIconList(AppIconList.State)
            case about(About.State)
        }
        
        enum Action: Equatable {
            case gradeSystemList(GradeSystemList.Action)
            case diagramConfiguration(DiagramConfiguration.Action)
            case appIconList(AppIconList.Action)
            case about(About.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.gradeSystemList, action: \.gradeSystemList) {
                GradeSystemList()
            }
            Scope(state: \.diagramConfiguration, action: \.diagramConfiguration) {
                DiagramConfiguration()
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
        case setDiagramConfigurationNavigation
        case setAppIconListNavigation
        case setAboutNavigation
        case deleteEntriesDidFinish(TaskResult<EntryClientResponse>)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.filterClient) var filterClient
    @Dependency(\.entryClient) var entryClient
    
    var body: some Reducer<State, Action> {
       Reduce { state, action in
            switch action {
            case let .destination(.presented(.gradeSystemList(.delete(id)))):
                return .merge(
                    .run { _ in filterClient.deleteFilterSystem(id) },
                    .run { send in
                        await send(
                            .deleteEntriesDidFinish(
                                TaskResult {
                                    entryClient.deleteEntries(id)
                                    return .finished
                                }
                            )
                        )
                    }
                )
                
            case .setGradeSystemListNavigation:
                state.destination = .gradeSystemList(.init())
                
            case .setDiagramConfigurationNavigation:
                state.destination = .diagramConfiguration(.init())
                
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
