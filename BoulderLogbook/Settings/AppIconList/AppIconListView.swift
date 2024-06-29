//
//  AppIconListView.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import SwiftUI
import ComposableArchitecture

struct AppIconListView: View {
    let store: StoreOf<AppIconList>

    var body: some View {
        PlainList {
            PlainSection {
                appIconRow(for: .classic)
            }
            PlainSection("App Icon Pack") {
                appIconRow(for: .aurora)
                appIconRow(for: .darkBerry)
            }
        }
        .navigationTitle("App Icons")
        .onAppear { store.send(.onAppear) }
    }
}

extension AppIconListView {
    func appIconRow(for icon: AppIconList.State.Icon) -> some View {
        Button {
            store.send(.selectAppIcon(icon.fileName))
        } label: {
            HStack {
                Text(icon.name)
                    .fontWeight(.medium)
                Spacer()
                AppIconView(iconName: icon.resourceName)

                let isClassicSelected = icon == .classic && store.currentIconName == nil
                let isAlternativeSelected = icon.fileName == store.currentIconName
                let isSelected = isClassicSelected || isAlternativeSelected
                Image(systemName: isSelected ? "checkmark.circle" : "circle")
                    .foregroundStyle(isSelected ? .success : .primaryText)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppIconListView(
            store: Store(
                initialState: .init()
            ) {
                AppIconList()
            }
        )
    }
}
