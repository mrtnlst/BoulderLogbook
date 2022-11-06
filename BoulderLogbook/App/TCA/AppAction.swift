//
//  AppAction.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import ComposableArchitecture

enum AppAction {
    case summary(SummaryAction)
    case form(FormAction)
    case filterSheet(FilterSheetAction)
    case setIsPresentingForm(Bool)
    case setIsPresentingFilter(Bool)
    case setPath([Store<EntryState, EntryAction>])
}
