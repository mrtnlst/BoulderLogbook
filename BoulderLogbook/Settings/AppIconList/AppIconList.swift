//
//  AppIconList.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import UIKit
import ComposableArchitecture

struct AppIconList: Reducer {
    struct State: Equatable {
        var inAppPurchase: InAppPurchase?
        var hasInAppPurchase: Bool = false
    }
    
    enum Action: Equatable {
        case onAppear
        case receiveInAppPurchase(TaskResult<InAppPurchase?>)
        case restorePurchase
        case receiveHasInAppPurchase(TaskResult<Bool>)
        case purchase
        case receivePurchaseResult(TaskResult<Bool>)
        case selectAppIcon(String?)
    }
    
    @Dependency(\.uiApplicationClient) var uiApplicationClient
    @Dependency(\.storeKitClient) var storeKitClient
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .merge (
                .run { send in
                    await send(.receiveInAppPurchase(TaskResult { try await storeKitClient.fetchProduct() }))
                },
                .run(priority: .background) { send in
                    await send(.receiveHasInAppPurchase(TaskResult { try await storeKitClient.observeUpdates() }))
                },
                .send(.restorePurchase)
            )
            
        case let .receiveInAppPurchase(.success(inAppPurchase)):
            state.inAppPurchase = inAppPurchase
            
        case let .receiveInAppPurchase(.failure(error)):
            state.inAppPurchase = nil
            print(error.localizedDescription)
            
        case .restorePurchase:
            return .run { send in
                await send(.receiveHasInAppPurchase(TaskResult { try await storeKitClient.fetchEntitlement() }))
            }
            
        case let .receiveHasInAppPurchase(.success(result)):
            state.hasInAppPurchase = result
            
        case let .receiveHasInAppPurchase(.failure(error)):
            state.hasInAppPurchase = false
            print(error.localizedDescription)
            
        case .purchase:
            guard state.inAppPurchase != nil, !state.hasInAppPurchase else {
                return .none
            }
            return .run { send in
                await send(.receivePurchaseResult(TaskResult { try await storeKitClient.purchase() }))
            }
            
        case let .receivePurchaseResult(.success(result)):
            state.hasInAppPurchase = result
            
        case let .receivePurchaseResult(.failure(error)):
            print(error.localizedDescription)
            state.hasInAppPurchase = false
            
        case let .selectAppIcon(iconName):
            return .run { _ in await uiApplicationClient.setAlternateIconName(iconName) }
        }
        return .none
    }
}
