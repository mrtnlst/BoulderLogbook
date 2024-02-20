//
//  SettingsView.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<Settings>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                PlainList {
                    Button {
                        viewStore.send(.setGradeSystemListNavigation)
                    } label: {
                        listItem(title: "Grade Systems", image: "square.fill.text.grid.1x2")
                    }
                    Button {
                        viewStore.send(.setDiagramConfigurationNavigation)
                    } label: {
                        listItem(title: "Diagrams", image: "chart.bar.xaxis")
                    }
                    Button {
                        viewStore.send(.setAppIconListNavigation)
                    } label: {
                        listItem(title: "App Icons", image: "app.dashed")
                    }
                    Button {
                        viewStore.send(.setAboutNavigation)
                    } label: {
                        listItem(title: "About", image: "info.circle")
                    }
                }
                .navigationTitle("Settings")
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.gradeSystemList,
                        action: \.destination.gradeSystemList
                    )
                ) {
                    GradeSystemListView(store: $0)
                }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.diagramConfiguration,
                        action: \.destination.diagramConfiguration
                    )
                ) {
                    DiagramConfigurationView(store: $0)
                }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.appIconList,
                        action: \.destination.appIconList
                    )
                ) {
                    AppIconListView(store: $0)
                }
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.about,
                        action: \.destination.about
                    )
                ) {
                    AboutView(store: $0)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                SettingsView(
                    store: Store(
                        initialState: Settings.State()
                    ) {
                        Settings()
                    }
                )
            }
    }
}
