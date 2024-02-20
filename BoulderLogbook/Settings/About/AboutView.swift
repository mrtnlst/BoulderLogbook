//
//  AboutView.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import SwiftUI
import ComposableArchitecture

struct AboutView: View {
    let store: StoreOf<About>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            PlainList {
                PlainSection {
                    VStack(alignment: .center) {
                        AppIconView(iconName: "AppIcon")
                        Text("Boulder Logbook")
                            .font(.headline)
                        Text("1.0.0")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
                PlainSection("Developed by") {
                    Button {
                        viewStore.send(.openMartin)
                    } label: {
                        Text("Martin List")
                    }
                    .foregroundColor(.accentColor)
                }
                PlainSection("Open Source Software") {
                    Button {
                        viewStore.send(.openTCA)
                    } label: {
                        Text("The Composable Architecture")
                    }
                    .foregroundColor(.accentColor)
                }
            }
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView(
                store: Store(initialState: .init()) {
                    About()
                }
            )
        }
    }
}
