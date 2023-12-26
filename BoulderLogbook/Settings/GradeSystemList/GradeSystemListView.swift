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
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                ForEach(viewStore.gradeSystems) { gradeSystem in
                    selectionRow(gradeSystem: gradeSystem)
                    .swipeActions { swipeButtons(gradeSystem: gradeSystem) }
                }
            }
            .confirmationDialog(
                store: store.scope(
                    state: \.$destination.confirmationDialog,
                    action: \.destination.confirmationDialog
                )
            )
            .sheet(
                store: store.scope(
                    state: \.$destination.gradeSystemForm,
                    action: \.destination.gradeSystemForm
                ),
                onDismiss: nil,
                content: {
                    GradeSystemFormView(store: $0)
                }
            )
            .navigationTitle("Grade Systems")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewStore.send(.presentGradeSystemForm)
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
    @ViewBuilder func selectionRow(gradeSystem: GradeSystem) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                            .foregroundColor(isSelected ? .jadeGreen : .secondary)
                    }
                }
            )
        }
    }
    
    @ViewBuilder func swipeButtons(gradeSystem: GradeSystem) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button(
                action: { viewStore.send(.setSystemToDelete(gradeSystem)) },
                label: { Label("Delete", systemImage: "trash") }
            )
            .tint(.indianRed)
            Button(
                action: { viewStore.send(.edit(gradeSystem.id)) },
                label: { Label("Edit", systemImage: "pencil") }
            )
            .tint(.hunyadiOrange)
        }
    }
}

struct GradeSystemListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GradeSystemListView(
                store: Store(
                    initialState: GradeSystemList.State()
                ) {
                    GradeSystemList()
                        .dependency(\.gradeSystemClient, .previewValue)
                }
            )
        }
    }
}
