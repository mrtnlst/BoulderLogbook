//
//  About.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import UIKit
import ComposableArchitecture

struct About: ReducerProtocol {
    struct State: Equatable {
        var appIcon: UIImage?
    }
    
    enum Action: Equatable {
        case task
        case receiveAppIcon(TaskResult<UIImage?>)
        case openMartin
        case openTCA
    }
    
    @Dependency(\.bundleClient) var bundleClient
    @Dependency(\.uiApplicationClient) var uiApplicationClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .task:
            return .task {
                await .receiveAppIcon(
                    TaskResult {
                        bundleClient.appIcon()
                    }
                )
            }
            
        case let .receiveAppIcon(.success(icon)):
            state.appIcon = icon
            
        case .openMartin:
            let urlString = "https://iosdev.space/@mrtnlst"
            return .fireAndForget {
                uiApplicationClient.openLink(urlString)
            }
            
        case .openTCA:
            let urlString = "https://github.com/pointfreeco/swift-composable-architecture/"
            return .fireAndForget {
                uiApplicationClient.openLink(urlString)
            }
            
        default: ()
        }
        return .none
    }
}
