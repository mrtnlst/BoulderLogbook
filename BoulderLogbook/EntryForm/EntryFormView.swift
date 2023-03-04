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
        NavigationView {
            Form {
                Section { gradeSystems() }
                Section { tops() }
                Section { datePicker() }
                Section { buttons() }
            }
            .navigationTitle("New Entry")
        }
    }
}

extension EntryFormView {
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
            .onAppear { viewStore.send(.onAppear) }
        }
    }
    
    @ViewBuilder func tops() -> some View {
        WithViewStore(store) { viewStore in
            ForEach(viewStore.selectedSystem?.grades ?? []) { grade in
                DisclosureGroup(
                    content: {
                        VStack {
                            stepper(
                                title: "Attempt: \(viewStore.attempts.count(for: grade))",
                                icon: "figure.fall",
                                color: grade.color,
                                onIncrement: { viewStore.send(.increaseAttempt(grade)) },
                                onDecrement: { viewStore.send(.decreaseAttempt(grade)) }
                            )
                            stepper(
                                title: "Flash: \(viewStore.flashs.count(for: grade))",
                                icon: "bolt.fill",
                                color: grade.color,
                                onIncrement: { viewStore.send(.increaseFlash(grade)) },
                                onDecrement: { viewStore.send(.decreaseFlash(grade)) }
                            )
                            stepper(
                                title: "Onsight: \(viewStore.onsights.count(for: grade))",
                                icon: "eye.fill",
                                color: grade.color,
                                onIncrement: { viewStore.send(.increaseOnsight(grade)) },
                                onDecrement: { viewStore.send(.decreaseOnsight(grade)) }
                            )
                        }
                    },
                    label: {
                        Stepper(
                            label: {
                                Label(
                                    title: {
                                        let count = viewStore.tops.count(for: grade)
                                        + viewStore.flashs.count(for: grade)
                                        + viewStore.onsights.count(for: grade)
                                        HStack(alignment: .firstTextBaseline) {
                                            Text("Tops: \(count)")
                                            Text("A: \(viewStore.attempts.count(for: grade))")
                                                .foregroundColor(.secondary)
                                        }
                                    },
                                    icon: {
                                        Image(systemName: "triangle.fill")
                                            .foregroundColor(grade.color)
                                    }
                                )
                            },
                            onIncrement: { viewStore.send(.increaseTop(grade)) },
                            onDecrement: { viewStore.send(.decreaseTop(grade)) }
                        )
                    }
                )
            }
        }
    }
    
    @ViewBuilder func stepper(
        title: String,
        icon: String,
        color: Color,
        onIncrement: @escaping () -> Void,
        onDecrement: @escaping () -> Void
    ) -> some View {
        Stepper(
            label: {
                Label(
                    title: { Text(title) },
                    icon: { Image(systemName: icon).foregroundColor(color) }
                )
            },
            onIncrement: onIncrement,
            onDecrement: onDecrement
        )
    }
            
    @ViewBuilder func datePicker() -> some View {
        WithViewStore(store) { viewStore in
            DatePicker(
                selection: viewStore.binding(\.$date),
                in: ...Date(),
                displayedComponents: [.hourAndMinute, .date]
            ) {
                Label(
                    title: { Text("Date") },
                    icon: { Image(systemName: "calendar") }
                )
                .foregroundColor(.primary)
            }
        }
    }
    
    @ViewBuilder func buttons() -> some View {
        WithViewStore(store) { viewStore in
            RectangularButton.save {
                viewStore.send(.save)
            }
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
                initialState: EntryForm.State(),
                reducer: EntryForm()
                    .dependency(\.gradeSystemClient, .previewValue)
            )
        )
    }
}
