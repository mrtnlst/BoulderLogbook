//
//  Settings.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import ComposableArchitecture

struct Settings: ReducerProtocol {
    struct State: Equatable {
        var gradeSystemList = GradeSystemList.State()
        var filterSheet = FilterSheet.State()
    }
    
    enum Action {
        case gradeSystemList(GradeSystemList.Action)
        case filterSheet(FilterSheet.Action)
        case deleteEntriesDidFinish(TaskResult<EntryClientResponse>)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.filterClient) var filterClient
    @Dependency(\.entryClient) var entryClient
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.gradeSystemList, action: /Action.gradeSystemList) {
            GradeSystemList()
        }
        Scope(state: \.filterSheet, action: /Action.filterSheet) {
            FilterSheet()
        }
        
        Reduce { state, action in
            switch action {
            case let .gradeSystemList(.delete(id)):
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
                
            default: ()
            }
            return .none
        }
    }
}
