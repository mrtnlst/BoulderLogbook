//
//  ColorPickerSheetFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 24.02.24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct ColorPickerFeature {
    struct State: Equatable {
        var grade: GradeSystem.Grade
    }

    enum Action: Equatable {
        case didSelectColor(Color, GradeSystem.Grade)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .didSelectColor(color, _):
            state.grade.color = color
        }
        return .none
    }
}
