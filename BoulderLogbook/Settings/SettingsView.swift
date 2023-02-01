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
                }
                .navigationTitle("Settings")
            }
        }
    }
}

extension SettingsView {
    @ViewBuilder func gradeSystemList() -> some View {
        WithViewStore(store) { viewStore in
            HStack {
                Image(systemName: "square.fill.text.grid.1x2")
                    .font(.title)
                    .foregroundColor(.accentColor)
                VStack(alignment: .leading) {
                    Text("Grade Systems")
                }
            }
        }
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
