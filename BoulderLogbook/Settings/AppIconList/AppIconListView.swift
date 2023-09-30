//
//  AppIconListView.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

import SwiftUI
import StoreKit
import ComposableArchitecture

struct AppIconListView: View {
    let store: StoreOf<AppIconList>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    appIconRow(title: "Classic Icon", fileName: "AppIcon")
                }
                Section("App Icon Pack") {
                    appIconRow(title: "Aurora", fileName: "AppIcon_2")
                    appIconRow(title: "Dark Berry", fileName: "AppIcon_3")
                }
                .disabled(!viewStore.hasInAppPurchase)
                .opacity(viewStore.hasInAppPurchase ? 1 : 0.6)
                
                Section {
                    inAppPurchaseView()
                }
            }
            .navigationTitle("App Icons")
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

extension AppIconListView {
    func inAppPurchaseView() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if !viewStore.hasInAppPurchase,
                   let inAppPurchase = viewStore.inAppPurchase {
                    RectangularButton(
                        title: "Buy \(inAppPurchase.displayName) - \(inAppPurchase.displayPrice)",
                        image: "creditcard.fill",
                        action: {
                            viewStore.send(.purchase)
                        }
                    )
                    .tint(.blueDeFrance)
                }
                Spacer(minLength: 8)
                if !viewStore.hasInAppPurchase {
                    Button("Restore Purchase") {
                        viewStore.send(.restorePurchase)
                    }
                    .buttonStyle(.plain)
                    .fontWeight(.medium)
                    .foregroundColor(.blueDeFrance)
                    .frame(maxWidth: .infinity)
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
    }
}

extension AppIconListView {
    func appIconRow(title: String, fileName: String) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(
                    .selectAppIcon(fileName == "AppIcon" ? nil : fileName)
                )
            } label: {
                HStack {
                    Text(title)
                        .fontWeight(.medium)
                    Spacer()
                    AppIconView(iconName: fileName)
                }
            }
        }
    }
}

struct AppIconListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AppIconListView(
                store: Store(
                    initialState: .init()
                ) {
                    AppIconList()
                }
            )
        }
    }
}
