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
                        gradeSystemList()
                    }
                    NavigationLink {
                        FilterSheetView(
                            store: store.scope(
                                state: \.filterSheet,
                                action: Settings.Action.filterSheet
                            )
                        )
                    } label: {
                        diagramFilter()
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
}

extension SettingsView {
    @ViewBuilder func gradeSystemList() -> some View {
        Label(
            title: {
                Text("Grade Systems")
            },
            icon: {
                Image(systemName: "square.fill.text.grid.1x2")
                    .foregroundColor(.primary)
            }
        )
    }
    
    @ViewBuilder func diagramFilter() -> some View {
        Label(
            title: {
                Text("Diagrams")
            },
            icon: {
                Image(systemName: "chart.bar.xaxis")
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
