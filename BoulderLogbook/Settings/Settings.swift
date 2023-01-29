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
        var gradeSystemList: GradeSystemList.State = GradeSystemList.State()
    }
    
    enum Action {
        case gradeSystemList(GradeSystemList.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.gradeSystemList, action: /Action.gradeSystemList) {
            GradeSystemList()
        }
        
        Reduce { _, _ in
            return .none
        }
    }
}
