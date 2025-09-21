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
                appIconRow(for: .default)
            }
            PlainSection("Classic Icons") {
                appIconRow(for: .aurora)
                appIconRow(for: .darkBerry)
                appIconRow(for: .lemon)
                appIconRow(for: .fairyDust)
                appIconRow(for: .midnight)
            }
        }
        .navigationTitle("App Icons")
        .toolbarTitleDisplayMode(.inline)
        .onAppear { store.send(.onAppear) }
    }
}

extension AppIconListView {
    func appIconRow(for icon: AppIconList.State.Icon) -> some View {
        PlainRowButton {
            store.send(.selectAppIcon(icon.fileName))
        } label: {
            HStack {
                Text(icon.name)
                    .fontWeight(.medium)
                Spacer()
                AppIconView(iconName: icon.name)
                AppIconView(iconName: icon.darkAppearance)

                let isDefaultSelected = icon == .default && store.currentIconName == nil
                let isAlternativeSelected = icon.fileName == store.currentIconName
                let isSelected = isDefaultSelected || isAlternativeSelected
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
