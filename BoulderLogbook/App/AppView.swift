//
//  AppView.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppReducer>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack(
                path: viewStore.binding(get: \.path, send: AppReducer.Action.setPath)
            ) {
                dashboardView()
            }
        }
    }
}

extension AppView {
    @ViewBuilder func dashboardView() -> some View {
        WithViewStore(store) { viewStore in
            DashboardView(
                store: store.scope(state: \.dashboardState, action: AppReducer.Action.dashboard)
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
                    send: AppReducer.Action.setIsPresentingForm
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.entryForm,
                        action: AppReducer.Action.entryForm
                    )
                ) { formStore in
                    EntryFormView(store: formStore)
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresentingFilter,
                    send: AppReducer.Action.setIsPresentingFilter
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.filterSheet,
                        action: AppReducer.Action.filterSheet
                    )
                ) { filterSheetStore in
                    FilterSheetView(store: filterSheetStore)
                }
                .presentationDetents([.medium])
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: AppReducer.State(
                    dashboard: Dashboard.State(Logbook.sampleLogbook)
                ),
                reducer: AppReducer()
            )
        )
    }
}
