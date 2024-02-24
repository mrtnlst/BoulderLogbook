//
//  ColorPickerSheet.swift
//  BoulderLogbook
//
//  Created by Martin List on 22.02.24.
//

import SwiftUI
import ComposableArchitecture

struct ColorPickerSheet: View {
    let store: StoreOf<ColorPickerFeature>

    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]

    var body: some View {
        ScrollView {
            WithViewStore(store, observe: \.grade) { viewStore in
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Color.araAll, id: \.self) { color in
                        Button {
                            viewStore.send(.didSelectColor(color, viewStore.state))
                        } label: {
                            let isSelected = viewStore.state.color.isEqual(to: color)
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle.fill")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .accentColor(color)
                    }
                }
                .padding()
            }
        }
        .background {
            Color.araRowBackground
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    Text("Test")
        .sheet(isPresented: .constant(true)) {
            ColorPickerSheet(
                store: Store(
                    initialState: .init(
                        grade: .init()
                    )
                ) {
                    ColorPickerFeature()
                }
            )
            .preferredColorScheme(.dark)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
}
