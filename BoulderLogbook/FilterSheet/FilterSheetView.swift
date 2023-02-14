//
//  FilterSheetView.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import SwiftUI
import ComposableArchitecture

struct FilterSheetView: View {
    let store: StoreOf<FilterSheet>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text("Configure Diagram")
                        Image(systemName: "switch.2")
                        Spacer()
                    }
                }
                Section { gradeSystems() }
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

extension FilterSheetView {
    @ViewBuilder func gradeSystems() -> some View {
        WithViewStore(store) { viewStore in
            Picker(
                selection: viewStore.binding(\.$selectedSystemId),
                content: {
                    Text("None")
                        .tag(UUID?.none)
                    ForEach(viewStore.gradeSystems) {
                        Text($0.name)
                            .tag($0.id as UUID?)
                    }
                },
                label: {
                    Label(
                        title: { Text("Grade System") },
                        icon: { Image(systemName: "square.fill.text.grid.1x2") }
                    )
                    .foregroundColor(.primary)
                }
            )
            .pickerStyle(.menu)
        }
    }
}

struct FilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Main View")
            .sheet(isPresented: .constant(true)) {
                FilterSheetView(
                    store: Store(
                        initialState: FilterSheet.State(
                            gradeSystems: [.mandala, .kletterarena]
                        ),
                        reducer: FilterSheet()
                    )
                )
                .presentationDetents([.medium])
            }
    }
}
