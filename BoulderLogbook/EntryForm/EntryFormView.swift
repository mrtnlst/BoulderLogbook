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
                Section {
                    tops()
                }
                Section {
                    datePicker()
                }
                Section {
                    buttons()
                }
                .listRowInsets(.zero)
            }
            .navigationTitle("New Entry")
        }
    }
}

extension EntryFormView {
    @ViewBuilder func tops() -> some View {
        WithViewStore(store) { viewStore in
            ForEach(LegacyBoulderGrade.allCases, id: \.self) { grade in
                Stepper {
                    HStack {
                        Image(systemName: grade == .white ? "circle" : "circle.fill")
                            .foregroundColor(grade == .white ? .none : grade.color)
                        Text("× \(viewStore.tops.numberOfGrades(for: grade))")
                    }
                } onIncrement: {
                    viewStore.send(.increase(grade))
                } onDecrement: {
                    viewStore.send(.decrease(grade))
                }
            }
        }
    }
    
    @ViewBuilder func datePicker() -> some View {
        WithViewStore(store) { viewStore in
            DatePicker(
                selection: viewStore.binding(\.$date),
                in: ...Date(),
                displayedComponents: [.hourAndMinute, .date]
            ) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Date")
                }
            }
        }
    }
    
    @ViewBuilder func buttons() -> some View {
        WithViewStore(store) { viewStore in
            RectangularButton(title: "Save", action: { viewStore.send(.save) })
                .foregroundColor(.green)
            
            RectangularButton(title: "Cancel", action: { viewStore.send(.cancel) })
                .foregroundColor(.red)
        }
    }
}

struct EntryFormView_Previews: PreviewProvider {
    static var previews: some View {
        EntryFormView(
            store: Store(
                initialState: EntryForm.State(),
                reducer: EntryForm()
            )
        )
    }
}
