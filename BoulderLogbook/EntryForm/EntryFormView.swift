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
        WithViewStore(store) { viewStore in
            NavigationView {
                Form {
                    Section {
                        ForEach(LegacyBoulderGrade.allCases, id: \.self) { grade in
                            Stepper {
                                HStack {
                                    Image(systemName: grade == .white ? "circle" : "circle.fill")
                                        .foregroundColor(grade == .white ? .none : grade.color)
                                    Text("× \(viewStore.entry.numberOfGrades(for: grade))")
                                }
                            } onIncrement: {
                                viewStore.send(.increase(grade))
                            } onDecrement: {
                                viewStore.send(.decrease(grade))
                            }
                        }
                    }
                    Section {
                        DatePicker(
                            selection: viewStore.binding(
                                get: \.entry.date,
                                send: EntryForm.Action.didSelectDate
                            ),
                            in: ...Date(),
                            displayedComponents: [.hourAndMinute, .date]
                        ) {
                            HStack {
                                Image(systemName: "calendar")
                                Text("Adjust date")
                            }
                        }
                    }
                    Section {
                        RectangularButton(title: "Save", action: { viewStore.send(.save) })
                            .foregroundColor(.green)
                        
                        RectangularButton(title: "Cancel", action: { viewStore.send(.cancel) })
                            .foregroundColor(.red)
                    }
                    .listRowInsets(.zero)
                }
                .navigationTitle("New Entry")
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView(
            store: Store(
                initialState: EntryForm.State(),
                reducer: EntryForm()
            )
        )
    }
}
