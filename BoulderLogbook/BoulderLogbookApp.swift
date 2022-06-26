//
//  BoulderLogbookApp.swift
//  Shared
//
//  Created by Martin List on 26.06.22.
//

import SwiftUI
import ComposableArchitecture

@main
struct BoulderLogbookApp: App {
    static var store = Store(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            storageService: StorageService()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AppView(store: Self.store)
            }
        }
    }
}
