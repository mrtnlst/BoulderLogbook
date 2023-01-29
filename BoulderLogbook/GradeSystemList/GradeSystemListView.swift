//
//  GradeSystemListView.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import SwiftUI
import ComposableArchitecture

struct GradeSystemListView: View {
    let store: StoreOf<GradeSystemList>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.gradeSystems) { gradeSystem in
                    selectionRow(
                        name: gradeSystem.name,
                        isSelected: gradeSystem == viewStore.selectedSystem
                    )
                }
            }
            .navigationTitle("Grade Systems")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension GradeSystemListView {
    @ViewBuilder func selectionRow(
        name: String,
        isSelected: Bool
    ) -> some View {
        HStack {
            Text(name)
            Spacer()
            Image(systemName: isSelected  ? "checkmark.circle" : "circle")
                .foregroundColor(isSelected ? .green : .secondary)
        }
    }
}

struct GradeSystemListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GradeSystemListView(
                store: Store(
                    initialState: GradeSystemList.State(),
                    reducer: GradeSystemList()
                )
            )
        }
    }
}
