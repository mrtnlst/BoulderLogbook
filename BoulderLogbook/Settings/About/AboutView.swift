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
        PlainList {
            PlainSection {
                VStack(alignment: .center) {
                    AppIconView(iconName: "Classic Icon")
                    Text("Boulder Logbook")
                        .font(.headline)
                    Text("1.3.0")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
            }
            PlainSection("Developed by") {
                Button {
                    store.send(.openMartin)
                } label: {
                    Text("Martin List")
                }
                .foregroundStyle(.accent)
            }
            PlainSection("Open Source Software") {
                Button {
                    store.send(.openTCA)
                } label: {
                    Text("The Composable Architecture")
                }
                .foregroundStyle(.accent)
            }
        }
        .navigationTitle("About")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        AboutView(
            store: Store(initialState: .init()) {
                About()
            }
        )
    }
}
