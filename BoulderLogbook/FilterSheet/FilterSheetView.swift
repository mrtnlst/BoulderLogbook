//
//  FilterSheetView.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import SwiftUI
import ComposableArchitecture

struct FilterSheetView: View {
    let store: Store<FilterSheetState, FilterSheetAction>
    
    @State var toggle: Bool = true
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text("Select visible grades")
                        Image(systemName: "switch.2")
                        Spacer()
                    }
                }
                Section {
                    ForEachStore(
                        store.scope(
                            state: \.filters,
                            action: FilterSheetAction.filter
                        )
                    ) { filterStore in
                        FilterView(store: filterStore)
                    }
                }
            }
        }
    }
}

struct FilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Main View")
            .sheet(isPresented: .constant(true)) {
                FilterSheetView(
                    store: Store(
                        initialState: FilterSheetState(),
                        reducer: filterSheetReducer,
                        environment: FilterSheetEnvironment(
                            mainQueue: .main,
                            fetch: { _ in return .none },
                            save: { _, _ in return .none }
                        )
                    )
                )
                .presentationDetents([.medium])
            }
    }
}
