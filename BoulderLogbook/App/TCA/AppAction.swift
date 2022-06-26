//
//  AppAction.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation

enum AppAction {
    case summary(SummaryAction)
    case form(FormAction)
    case setIsPresentingForm(Bool)
}
