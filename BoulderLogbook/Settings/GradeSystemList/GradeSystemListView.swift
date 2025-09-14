//
//  GradeSystemListView.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import SwiftUI
import ComposableArchitecture

struct GradeSystemListView: View {
    @Bindable var store: StoreOf<GradeSystemList>

    var body: some View {
        PlainList {
            ForEach(store.gradeSystems) { gradeSystem in
                selectionRow(gradeSystem: gradeSystem)
                    .swipeActions { swipeButtons(gradeSystem: gradeSystem) }
            }
        }
        .confirmationDialog(
            $store.scope(
                state: \.destination?.confirmationDialog,
                action: \.destination.confirmationDialog
            )
        )
        .sheet(
            item: $store.scope(
                state: \.destination?.gradeSystemForm,
                action: \.destination.gradeSystemForm
            )
        ) {
            GradeSystemFormView(store: $0)
        }
        .navigationTitle("Grade Systems")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarSpacer(.flexible, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button {
                    store.send(.presentGradeSystemForm)
                } label: {
                    Label("Add grade system", systemImage: "plus")
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

extension GradeSystemListView {
    func selectionRow(gradeSystem: GradeSystem) -> some View {
        Button {
            store.send(.saveSelected(gradeSystem.id))
        } label: {
            let isSelected = store.selectedSystem?.id == gradeSystem.id
            HStack {
                Text(gradeSystem.name)
                    .foregroundStyle(.primaryText)
                    .font(.body)
                Spacer()
                Text(isSelected ? "Default" : "")
                    .foregroundStyle(.tertiaryText)
                    .font(.headline)
                    .fontWeight(.regular)
                Image(systemName: isSelected  ? "checkmark.circle" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? .success : .tertiaryText)
            }
        }
    }
    
    @ViewBuilder
    func swipeButtons(gradeSystem: GradeSystem) -> some View {
        Button {
            store.send(.setSystemToDelete(gradeSystem))
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.araError)
        Button {
            store.send(.edit(gradeSystem.id))
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.araWarning)
    }
}

#Preview {
    NavigationView {
        GradeSystemListView(
            store: Store(
                initialState: GradeSystemList.State()
            ) {
                GradeSystemList()
                    .dependency(GradeSystemClient.previewValue)
            }
        )
    }
}
