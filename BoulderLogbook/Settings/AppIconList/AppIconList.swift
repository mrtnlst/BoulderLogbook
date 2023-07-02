//
//  AppIconList.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import UIKit
import ComposableArchitecture

struct AppIconList: ReducerProtocol {
    struct State: Equatable {}
    
    enum Action: Equatable {
        case selectAppIcon(String?)
    }
    
    @Dependency(\.uiApplicationClient) var uiApplicationClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .selectAppIcon(iconName):
            return .run { _ in await uiApplicationClient.setAlternateIconName(iconName) }
        }
    }
}
