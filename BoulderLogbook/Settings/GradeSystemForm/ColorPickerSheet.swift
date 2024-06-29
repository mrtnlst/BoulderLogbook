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
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Color.araAll, id: \.self) { color in
                    Button {
                        store.send(.didSelectColor(color, store.grade))
                    } label: {
                        let isSelected = store.grade.color.isEqual(to: color)
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle.fill")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .accentColor(color)
                }
            }
            .padding()
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
