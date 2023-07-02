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
        List {
            Section {
                appIconRow(title: "Classic Icon", fileName: "AppIcon")
            }
            Section("Unlockable via In-App Purchase") {
                appIconRow(title: "Aurora", fileName: "AppIcon_2")
                appIconRow(title: "Dark Berry", fileName: "AppIcon_3")
            }
        }
        .navigationTitle("App Icons")
    }
}

extension AppIconListView {
    func appIconRow(title: String, fileName: String) -> some View {
        WithViewStore(store) { viewStore in
            Button {
                viewStore.send(
                    .selectAppIcon(fileName == "AppIcon" ? nil : fileName)
                )
            } label: {
                HStack {
                    Text(title)
                        .fontWeight(.medium)
                    Spacer()
                    AppIconView(iconName: fileName)
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
                    initialState: .init(),
                    reducer: AppIconList()
                )
            )
        }
    }
}
