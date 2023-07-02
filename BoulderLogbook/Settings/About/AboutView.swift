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
        WithViewStore(store) { viewStore in
            VStack {
                Spacer(minLength: 20)
                AppIconView(iconName: "AppIcon")
                Text("Boulder Logbook")
                    .font(.headline)
                Text("1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                List {
                    Section("Developed by") {
                        Button(
                            action: {
                                viewStore.send(.openMartin)
                            },
                            label: {
                                Text("Martin List")
                            }
                        )
                        .foregroundColor(.blue)
                    }
                    .listSectionSeparator(.hidden)
                    Section("Open Source Software") {
                        Button(
                            action: {
                                viewStore.send(.openTCA)
                            },
                            label: {
                                Text("The Composable Architecture")
                            }
                        )
                        .foregroundColor(.blue)
                        
                    }
                    .listSectionSeparator(.hidden)
                }
                .buttonStyle(PlainButtonStyle())
                .listStyle(.plain)
                
            }
            .navigationTitle("About")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutView(
                store: Store(initialState: .init(), reducer: About())
            )
        }
    }
}
