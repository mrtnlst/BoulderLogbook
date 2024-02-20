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
            PlainList {
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
            Button {
                viewStore.send(.saveSelected(gradeSystem.id))
            } label: {
                let isSelected = viewStore.selectedSystem?.id == gradeSystem.id
                HStack {
                    Text(gradeSystem.name)
                        .foregroundStyle(.primaryText)
                        .font(.body)
                    Spacer()
                    Text(isSelected ? "Default" : "")
                        .foregroundStyle(.tertiaryText)
                        .font(.subheadline)
                    Image(systemName: isSelected  ? "checkmark.circle" : "circle")
                        .foregroundColor(isSelected ? .araSuccess : .tertiaryText)
                }
            }
        }
    }
    
    @ViewBuilder func swipeButtons(gradeSystem: GradeSystem) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.setSystemToDelete(gradeSystem))
            } label: { 
                Label("Delete", systemImage: "trash")
            }
            .tint(.araError)
            Button {
                viewStore.send(.edit(gradeSystem.id))
            } label: { 
                Label("Edit", systemImage: "pencil")
            }
            .tint(.araWarning)
        }
    }
}

#Preview {
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
