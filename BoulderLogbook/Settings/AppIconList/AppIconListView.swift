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
            appIconRow(title: "Classic Icon", fileName: "AppIcon")
            appIconRow(title: "Alternative 1", fileName: "AppIcon_2")
            appIconRow(title: "Alternative 2", fileName: "AppIcon_3")
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
        AppIconListView(
            store: Store(
                initialState: .init(),
                reducer: AppIconList()
            )
        )
    }
}
