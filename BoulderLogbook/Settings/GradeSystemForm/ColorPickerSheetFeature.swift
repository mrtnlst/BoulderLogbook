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
    @ObservableState
    struct State: Equatable {
        var grade: Grade
    }

    enum Action: Equatable {
        case didSelectColor(Color, Grade)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .didSelectColor(color, _):
            state.grade.color = color
        }
        return .none
    }
}
