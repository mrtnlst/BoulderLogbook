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
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    NavigationLink {
                        GradeSystemListView(
                            store: store.scope(
                                state: \.gradeSystemList,
                                action: Settings.Action.gradeSystemList
                            )
                        )
                    } label: {
                        listItem(title: "Grade Systems", image: "square.fill.text.grid.1x2")
                    }
                    NavigationLink {
                        FilterSheetView(
                            store: store.scope(
                                state: \.filterSheet,
                                action: Settings.Action.filterSheet
                            )
                        )
                    } label: {
                        listItem(title: "Diagrams", image: "chart.bar.xaxis")
                    }
                    NavigationLink {
                        AboutView(
                            store: Store(
                                initialState: About.State(),
                                reducer: About()
                            )
                        )
                    } label: {
                        listItem(title: "About", image: "info.circle")
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
}

private extension SettingsView {
    @ViewBuilder func listItem(title: String, image: String) -> some View {
        Label(
            title: {
                Text(title)
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
