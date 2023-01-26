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
        initialState: AppReducer.State(),
        reducer: AppReducer(
            storageService: StorageService()
        )
    )
    
    var body: some Scene {
        WindowGroup {
            AppView(store: Self.store)
        }
    }
}
