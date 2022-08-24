//
//  SummarySectionReducer.swift
//  BoulderLogbook
//
//  Created by martin on 31.07.22.
//

import Foundation
import ComposableArchitecture

let summarySectionReducer = Reducer<SummarySectionState, SummarySectionAction, SummarySectionEnvironment> { state, action, environment in
    switch action {
    case .delete(_):
        return .none
        
    case .edit(_):
        return .none
    
    case .entryAction(id: _, action: _):
        return .none
    }
}
