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
                    Button {
                        viewStore.send(.saveSelected(gradeSystem.id))
                    } label: {
                        selectionRow(
                            name: gradeSystem.name,
                            isSelected: viewStore.selectedSystem?.id == gradeSystem.id 
                        )
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewStore.send(.delete(gradeSystem.id))
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        Button {
                            viewStore.send(.edit(gradeSystem.id))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .navigationTitle("Grade Systems")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.setIsPresentingForm(true))
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresentingForm,
                    send: GradeSystemList.Action.setIsPresentingForm
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.gradeSystemForm,
                        action: GradeSystemList.Action.gradeSystemForm
                    )
                ) { formStore in
                    GradeSystemFormView(store: formStore)
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
                        .dependency(\.gradeSystemClient, .previewValue)
                )
            )
        }
    }
}
