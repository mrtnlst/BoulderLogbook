//
//  KeypadView.swift
//  BoulderLogbook
//
//  Created by Martin List on 11.10.26.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: KeypadFeature.self)
struct KeypadView: View {
    @Environment(\.isEnabled) var isEnabled
    let store: StoreOf<KeypadFeature>

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 0
        ) {
            ForEach(store.keys) { key in
                Button {
                    send(.didPressKey(key))
                } label: {
                    Group {
                        if key.isSymbol {
                            Image(systemName: key.id)
                        } else {
                            Text(key.id)
                        }
                    }
                    .font(.title)
                    .frame(width: 60, height: 60)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                }
                .buttonStyle(.keypad)
            }
        }
        .sensoryFeedback(.decrease, trigger: store.value) { oldValue, newValue in
            oldValue.count > newValue.count
        }
        .sensoryFeedback(.increase, trigger: store.value) { oldValue, newValue in
            oldValue.count <= newValue.count
        }
        .animation(.easeInOut, value: store.keys)
        .opacity(isEnabled ? 1.0 : 0.4)
    }
}

#Preview {
    PlainList {
        KeypadView(
            store: Store(initialState: .init()) {
                KeypadFeature()
            }
        )
    }
}
