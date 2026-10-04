//
//  GradeSystemListView.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: GradeSystemList.self)
struct GradeSystemListView: View {
    @Bindable var store: StoreOf<GradeSystemList>

    var body: some View {
        PlainList {
            PlainSection {
                ForEach(store.gradeSystems) { gradeSystem in
                    selectionRow(gradeSystem: gradeSystem)
                        .swipeActions {
                            swipeButtons(gradeSystem: gradeSystem)
                        }
                }
            }
            PlainSection("Insights & Trends") {
                focusGradePicker
            }
        }
        .navigationTitle("Grade Systems")
        .toolbarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .alert(
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
    }
}

private extension GradeSystemListView {
    func selectionRow(gradeSystem: GradeSystem) -> some View {
        PlainRowButton {
            store.send(.saveSelected(gradeSystem))
        } label: {
            let isSelected = store.defaultGradeSystem?.id == gradeSystem.id
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
            send(.setSystemToDelete(gradeSystem))
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.araError)
        Button {
            send(.edit(gradeSystem.id))
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.araWarning)
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                send(.presentGradeSystemForm)
            } label: {
                Label("Add grade system", systemImage: "plus")
            }
        }
    }
    
    var focusGradePicker: some View {
        Picker(selection: $store.focusedGrade.sending(\.setFocusGrade)) {
            Text("None")
                .tag(Grade?.none)
            ForEach(store.defaultGradeSystem?.grades ?? []) {
                Text($0.name)
                    .tag($0)
            }
        } label: {
            Label {
                Text("Focus Grade")
                    .foregroundStyle(.primaryText)
                Text("Derived from default grade system")
                    .foregroundStyle(.tertiaryText)
            } icon: {
                Image(systemName: "waveform.path.ecg.magnifyingglass")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.araLightRed, .white)
            }
        }
        .tint(.accent)
    }
}

#Preview {
    NavigationView {
        GradeSystemListView(
            store: Store(
                initialState: GradeSystemList.State(
                    gradeSystems: Shared(value: [.mandala2])
                )
            ) {
                GradeSystemList()
                    .dependency(GradeSystemClient.previewValue)
            }
        )
    }
}
