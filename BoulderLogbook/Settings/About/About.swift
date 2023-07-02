//
//  About.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import UIKit
import ComposableArchitecture

struct About: ReducerProtocol {
    struct State: Equatable {}
    
    enum Action: Equatable {
        case openMartin
        case openTCA
    }
    
    @Dependency(\.uiApplicationClient) var uiApplicationClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .openMartin:
            let urlString = "https://iosdev.space/@mrtnlst"
            return .run { _ in await uiApplicationClient.openLink(urlString) }
            
        case .openTCA:
            let urlString = "https://github.com/pointfreeco/swift-composable-architecture/"
            return .run { _ in await uiApplicationClient.openLink(urlString) }
        }
    }
}
