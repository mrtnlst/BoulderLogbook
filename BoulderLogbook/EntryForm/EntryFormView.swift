//
//  EntryFormView.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import SwiftUI
import ComposableArchitecture

struct EntryFormView: View {
    let store: StoreOf<EntryForm>
    
    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { viewStore in
                PlainList {
                    PlainSection { gradeSystems() }
                    PlainSection { tops() }
                    PlainSection { datePicker() }
                    PlainSection { notes() }
                    PlainSection { buttons() }
                }
                .navigationTitle(viewStore.isEditing ? "Update Entry" : "New Entry")
                .scrollDismissesKeyboard(.interactively)
                .onAppear { viewStore.send(.onAppear) }
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension EntryFormView {
    @MainActor func gradeSystems() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Picker(selection: viewStore.$selectedSystemId) {
                Text("None")
                    .tag(UUID?.none)
                ForEach(viewStore.gradeSystems) {
                    Text($0.name)
                        .tag($0.id as UUID?)
                }
            } label: {
                Label(
                    title: { Text("Grade System") },
                    icon: { Image(systemName: "square.fill.text.grid.1x2") }
                )
                .foregroundStyle(.primaryText)
            }
            .pickerStyle(.menu)
            .disabled(viewStore.isEditing)
        }
    }
    
    @ViewBuilder func tops() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ForEach(viewStore.selectedSystem?.grades ?? []) { grade in
                DisclosureGroup {
                    VStack {
                        stepper(
                            title: "Attempt: \(viewStore.attempts.count(for: grade))",
                            icon: "figure.fall",
                            color: grade.color,
                            value: viewStore.binding(
                                get: \.attempts.count,
                                send: { .attemptStepperChanged($0, grade) }
                            )
                        )
                        stepper(
                            title: "Flash: \(viewStore.flashs.count(for: grade))",
                            icon: "bolt.fill",
                            color: grade.color,
                            value: viewStore.binding(
                                get: \.flashs.count,
                                send: { .flashStepperChanged($0, grade) }
                            )
                        )
                        stepper(
                            title: "Onsight: \(viewStore.onsights.count(for: grade))",
                            icon: "eye.fill",
                            color: grade.color,
                            value: viewStore.binding(
                                get: \.onsights.count,
                                send: { .onsightStepperChanged($0, grade) }
                            )
                        )
                    }
                } label: {
                    Stepper(
                        value: viewStore.binding(get: \.tops.count, send: { .topStepperChanged($0, grade)} ),
                        label: {
                            Label {
                                let count = viewStore.tops.count(for: grade)
                                + viewStore.flashs.count(for: grade)
                                + viewStore.onsights.count(for: grade)
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Tops: \(count)")
                                        .foregroundStyle(.primaryText)
                                    Text("A: \(viewStore.attempts.count(for: grade))")
                                        .foregroundStyle(.tertiaryText)
                                }
                            } icon: {
                                Image(systemName: "triangle.fill")
                                    .foregroundColor(grade.color)
                            }
                        }
                    )
                }
            }
        }
    }
    
    @ViewBuilder func stepper(
        title: String,
        icon: String,
        color: Color,
        value: Binding<Int>
    ) -> some View {
        Stepper(
            value: value,
            label: {
                Label {
                    Text(title)
                        .foregroundStyle(.primaryText)
                } icon: {
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
            }
        )
    }

    @MainActor func datePicker() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            DatePicker(
                selection: viewStore.$date,
                in: ...Date(),
                displayedComponents: [.hourAndMinute, .date]
            ) {
                Label(
                    title: { Text("Date") },
                    icon: { Image(systemName: "calendar") }
                )
                .foregroundStyle(.primaryText)
            }
        }
    }
    
    @MainActor func notes() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let isNotEdited = viewStore.notes == viewStore.notesPlaceHolder
            TextEditor(text: viewStore.$notes)
                .textEditorStyle(.plain)
                .foregroundStyle(isNotEdited ? .secondaryText : .primaryText)
                .onTapGesture {
                    if isNotEdited {
                        viewStore.send(.binding(.set(\.$notes, "")))
                    }
                }
        }
    }
    
    @ViewBuilder func buttons() -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            RectangularButton.save {
                viewStore.send(.save)
            }
            .disabled(viewStore.selectedSystemId == nil)
            RectangularButton.cancel {
                viewStore.send(.cancel)
            }
        }
    }
}

struct EntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView(
            store: Store(
                initialState: EntryForm.State()
            ) {
                EntryForm()
                    .dependency(\.gradeSystemClient, .previewValue)
            }
        )
    }
}
