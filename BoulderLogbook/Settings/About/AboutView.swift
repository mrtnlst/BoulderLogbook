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
                appIcon(icon: viewStore.appIcon)
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
            .task { await viewStore.send(.task).finish() }
        }
    }
}

extension AboutView {
    @ViewBuilder func appIcon(icon: UIImage?) -> some View {
        if let icon = icon {
            Image(uiImage: icon)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(radius: 4)
        } else {
            Image(systemName: "app.dashed")
                .resizable()
                .frame(width: 60, height: 60)
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
