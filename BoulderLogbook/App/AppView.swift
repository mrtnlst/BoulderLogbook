//
//  AppView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        if #available(iOS 16.0, *) {
#if canImport(Charts)
            NavigationStack(
                path: ViewStore(store).binding(get: \.path, send: AppAction.setPath)
            ) {
                summaryView(with: store)
            }
#endif
        } else {
            NavigationView {
                summaryView(with: store)
            }
            .navigationViewStyle(.stack)
        }
    }
}

extension AppView {
    @ViewBuilder func summaryView(with store: Store<AppState, AppAction>) -> some View {
        WithViewStore(store) { viewStore in
            SummaryView(
                store: store.scope(state: \.summaryState, action: AppAction.summary)
            )
            .toolbar {
                Button {
                    viewStore.send(.setIsPresentingForm(true))
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresentingForm,
                    send: AppAction.setIsPresentingForm
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.formState,
                        action: AppAction.form
                    )
                ) { formStore in
                    FormView(store: formStore)
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(
                    storageService: StorageService()
                )
            )
        )
    }
}
