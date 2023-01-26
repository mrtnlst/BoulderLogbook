//
//  FilterView.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import SwiftUI
import ComposableArchitecture

struct FilterView: View {
    let store: StoreOf<Filter>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Toggle(
                isOn: viewStore.binding(
                    get: \.isOn,
                    send: Filter.Action.setIsOn
                )
            ) {
                HStack {
                    Image(systemName: viewStore.grade == .white ? "circle" : "circle.fill")
                        .foregroundColor(viewStore.grade == .white ? .none : viewStore.grade.color)
                    Text(viewStore.grade.gradeDescription)
                }
            }
            .onAppear { viewStore.send(.fetch) }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            FilterView(
                store: Store(
                    initialState: Filter.State(grade: .blue, isOn: true),
                    reducer: Filter()
                )
            )
            
            FilterView(
                store: Store(
                    initialState: Filter.State(grade: .red, isOn: false),
                    reducer: Filter()
                )
            )
        }
    }
}
