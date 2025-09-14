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
    static let dependencies = Dependencies()
    static var store = Store(
        initialState: AppReducer.State()
    ) {
        AppReducer()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AppView(store: Self.store)
            }
            .tint(.toolbarButtonColor)
            .preferredColorScheme(.dark)
        }
    }
}
