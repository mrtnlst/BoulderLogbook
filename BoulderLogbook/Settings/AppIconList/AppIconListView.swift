//
//  AppIconListView.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import SwiftUI
import StoreKit
import ComposableArchitecture

struct AppIconListView: View {
    let store: StoreOf<AppIconList>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    appIconRow(for: .classic)
                }
                Section("App Icon Pack") {
                    appIconRow(for: .aurora)
                    appIconRow(for: .darkBerry)
                }
            }
            .navigationTitle("App Icons")
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

extension AppIconListView {
    func appIconRow(for icon: AppIconList.State.Icon) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(
                    .selectAppIcon(icon.fileName)
                )
            } label: {
                HStack {
                    Text(icon.name)
                        .fontWeight(.medium)
                    Spacer()
                    AppIconView(iconName: icon.resourceName)
                    
                    let isClassicSelected = icon == .classic && viewStore.currentIconName == nil
                    let isAlternativeSelected = icon.fileName == viewStore.currentIconName
                    let isSelected = isClassicSelected || isAlternativeSelected
                    Image(systemName: isSelected ? "checkmark.circle" : "circle")
                        .foregroundColor(isSelected ? .jadeGreen : .secondary)
                }
            }
        }
    }
}

struct AppIconListView_Previews: PreviewProvider {
    static var previews: some View {
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
}
