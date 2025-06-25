//
//  SettingsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    @Bindable var store: StoreOf<Settings>

    var body: some View {
        NavigationStack {
            PlainList {
                Button {
                    store.send(.setGradeSystemListNavigation)
                } label: {
                    listItem(title: "Grade Systems", image: "square.fill.text.grid.1x2")
                }
                Button {
                    store.send(.setAppIconListNavigation)
                } label: {
                    listItem(title: "App Icons", image: "app.dashed")
                }
                Button {
                    store.send(.setAboutNavigation)
                } label: {
                    listItem(title: "About", image: "info.circle")
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.gradeSystemList,
                    action: \.destination.gradeSystemList
                )
            ) {
                GradeSystemListView(store: $0)
            }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.appIconList,
                    action: \.destination.appIconList
                )
            ) {
                AppIconListView(store: $0)
            }
            .navigationDestination(
                item: $store.scope(
                    state: \.destination?.about,
                    action: \.destination.about
                )
            ) {
                AboutView(store: $0)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .close) {
                        store.send(.dismiss)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

private extension SettingsView {
    @ViewBuilder func listItem(title: String, image: String) -> some View {
        Label(
            title: {
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.primaryText)
                }
            },
            icon: {
                Image(systemName: image)
                    .foregroundStyle(.primaryText)
            }
        )
    }
}

#Preview {
    Text("").sheet(isPresented: .constant(true)) {
        SettingsView(
            store: Store(
                initialState: Settings.State()
            ) {
                Settings()
            }
        )
    }
}
