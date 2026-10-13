//
//  KeypadFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 11.10.26.
//

import ComposableArchitecture

@Reducer
struct KeypadFeature {
    @ObservableState
    struct State {
        var keys: [KeypadKey] = [
            KeypadKey(id: "1"),
            KeypadKey(id: "2"),
            KeypadKey(id: "3"),
            KeypadKey(id: "4"),
            KeypadKey(id: "5"),
            KeypadKey(id: "6"),
            KeypadKey(id: "7"),
            KeypadKey(id: "8"),
            KeypadKey(id: "9"),
            .deleteKey,
            KeypadKey(id: "0"),
            .clearKey
        ]
        var value: String = ""
    }
    
    enum Action: ViewAction {
        enum Delegate {
            case didUpdateValue(String)
            case didPressSaveKey(String)
            case didPressClearKey
        }
        enum View {
            case didPressKey(KeypadKey)
        }
        case resetValue
        case delegate(Delegate)
        case view(View)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(.didPressKey(key)):
                switch key {
                case .deleteKey:
                    if !state.value.isEmpty {
                        state.value.removeLast()
                    }
                    if state.value.isEmpty {
                        resetValue(in: &state)
                    }
                    return .send(.delegate(.didUpdateValue(state.value)))
                case .saveKey:
                    let finalValue = state.value
                    resetValue(in: &state)
                    return .merge(
                        .send(.delegate(.didPressSaveKey(finalValue))),
                        .send(.delegate(.didUpdateValue(state.value)))
                    )
                case .clearKey:
                    resetValue(in: &state)
                    return .merge(
                        .send(.delegate(.didPressClearKey)),
                        .send(.delegate(.didUpdateValue(state.value)))
                    )

                default:
                    var isZeroOnZero = false
                    if state.value == "0" {
                        isZeroOnZero = state.value == key.id
                        state.value = key.id
                    } else {
                        state.value.append(key.id)
                    }
                    if !isZeroOnZero, let indexOfClearKey = state.keys.firstIndex(of: .clearKey) {
                        state.keys[indexOfClearKey] = .saveKey
                    }
                    return .send(.delegate(.didUpdateValue(state.value)))
                }

            default: ()
            }
            return .none
        }
    }
}

private extension KeypadFeature {
    func resetValue(in state: inout State) {
        state.value = "0"
        if let indexOfSaveKey = state.keys.firstIndex(of: .saveKey) {
            state.keys[indexOfSaveKey] = .clearKey
        }
    }
}
