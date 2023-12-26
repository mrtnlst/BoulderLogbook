//
//  AppIconList.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import UIKit
import ComposableArchitecture

@Reducer
struct AppIconList {
    struct State: Equatable {
        var currentIconName: String?
        
        enum Icon {
            case classic
            case aurora
            case darkBerry
            
            var name: String {
                switch self {
                case .classic: return "Classic Icon"
                case .aurora: return "Aurora"
                case .darkBerry: return "Dark Berry"
                }
            }
            
            var resourceName: String {
                switch self {
                case .classic: return "AppIcon"
                case .aurora: return "AppIcon_2"
                case .darkBerry: return "AppIcon_3"
                }
            }
            
            var fileName: String? {
                switch self {
                case .classic: return nil
                default: return resourceName
                }
            }
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchCurrentIconName
        case receiveCurrentIconName(TaskResult<String?>)
        case selectAppIcon(String?)
    }
    
    @Dependency(\.uiApplicationClient) var uiApplicationClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in await send(.fetchCurrentIconName) }
            
        case .fetchCurrentIconName:
            return .run { send in 
                await send(
                    .receiveCurrentIconName(
                        TaskResult { await uiApplicationClient.currentIconName() }
                    )
                )
            }
            
        case let .receiveCurrentIconName(.success(iconName)):
            state.currentIconName = iconName
            
        case let .selectAppIcon(iconName):
            return .merge(
                .run { _ in await uiApplicationClient.setAlternateIconName(iconName) },
                .run { send in await send(.fetchCurrentIconName) }
            )
            
        default: ()
        }
        return .none
    }
}
