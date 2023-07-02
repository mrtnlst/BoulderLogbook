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
            WithViewStore(store) { viewStore in
                List {
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
                    store: store.scope(state: \.$destination, action: { .destination($0) }),
                    state: /Settings.Destination.State.gradeSystemList,
                    action: Settings.Destination.Action.gradeSystemList
                ) {
                    GradeSystemListView(store: $0)
                }
                .navigationDestination(
                    store: store.scope(state: \.$destination, action: { .destination($0) }),
                    state: /Settings.Destination.State.diagramConfiguration,
                    action: Settings.Destination.Action.diagramConfiguration
                ) {
                    FilterSheetView(store: $0)
                }
                .navigationDestination(
                    store: store.scope(state: \.$destination, action: { .destination($0) }),
                    state: /Settings.Destination.State.appIconList,
                    action: Settings.Destination.Action.appIconList
                ) {
                    AppIconListView(store: $0)
                }
                .navigationDestination(
                    store: store.scope(state: \.$destination, action: { .destination($0) }),
                    state: /Settings.Destination.State.about,
                    action: Settings.Destination.Action.about
                ) {
                    AboutView(store: $0)
                }
            }
        }
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
                        .foregroundColor(.secondary)
                }
            },
            icon: {
                Image(systemName: image)
                    .foregroundColor(.primary)
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            store: Store(
                initialState: Settings.State(),
                reducer: Settings()
            )
        )
    }
}
