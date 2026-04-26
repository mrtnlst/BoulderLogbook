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
    } withDependencies: {
        $0.gradeSystemClient = BoulderLogbookApp.dependencies.gradeSystemService.toClient()
        $0.logbookEntryClient = BoulderLogbookApp.dependencies.logbookEntryService.toClient()
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: Self.store)
        }
    }
}
