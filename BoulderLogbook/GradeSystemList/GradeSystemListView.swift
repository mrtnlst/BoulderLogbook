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
    @State var showConfirmation = false
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.gradeSystems) { gradeSystem in
                    selectionRow(gradeSystem: gradeSystem)
                    .swipeActions { swipeButtons(gradeSystem: gradeSystem) }
                    .alert(
                        "Warning",
                        isPresented: $showConfirmation,
                        actions: {
                            Button(
                                "Delete",
                                role: .destructive,
                                action: { viewStore.send(.delete(gradeSystem.id)) }
                            )
                        },
                        message: {
                            Text("Deleting a grade system deletes all associated logbook entries!")
                        }
                    )
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
    @ViewBuilder func selectionRow(gradeSystem: GradeSystem) -> some View {
        WithViewStore(store) { viewStore in
            Button(
                action: { viewStore.send(.saveSelected(gradeSystem.id)) },
                label: {
                    let isSelected = viewStore.selectedSystem?.id == gradeSystem.id
                    HStack {
                        Text(gradeSystem.name)
                            .foregroundColor(.primary)
                            .font(.body)
                        Spacer()
                        Text(isSelected ? "Default" : "")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        Image(systemName: isSelected  ? "checkmark.circle" : "circle")
                            .foregroundColor(isSelected ? .green : .secondary)
                    }
                }
            )
        }
    }
    
    @ViewBuilder func swipeButtons(gradeSystem: GradeSystem) -> some View {
        WithViewStore(store) { viewStore in
            Button(
                action: { showConfirmation = true },
                label: { Label("Delete", systemImage: "trash") }
            )
            .tint(.red)
            Button(
                action: { viewStore.send(.edit(gradeSystem.id)) },
                label: { Label("Edit", systemImage: "pencil") }
            )
            .tint(.orange)
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
