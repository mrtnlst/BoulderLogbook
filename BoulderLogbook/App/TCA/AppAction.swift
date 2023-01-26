//
//  AppAction.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import ComposableArchitecture

enum AppAction {
    case dashboard(Dashboard.Action)
    case entryForm(EntryForm.Action)
    case filterSheet(FilterSheet.Action)
    case setIsPresentingForm(Bool)
    case setIsPresentingFilter(Bool)
    case setPath([StoreOf<EntryDetail>])
}
