//
//  FormView.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import SwiftUI
import ComposableArchitecture

struct FormView: View {
    let store: Store<FormState, FormAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text("Log your boulder session")
                        Image(systemName: "pencil")
                        Spacer()
                    }
                }
                Section {
                    ForEach(BoulderGrade.allCases, id: \.self) { grade in
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
                if viewStore.isNewEntry {
                    Section {
                        DatePicker(
                            selection: viewStore.binding(
                                get: \.entry.date,
                                send: FormAction.didSelectDate
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
                }
                Section {
                    buttonView(text: "Save", action: { viewStore.send(.save) })
                    .foregroundColor(.green)
                    
                    buttonView(text: "Cancel", action: { viewStore.send(.cancel) })
                    .foregroundColor(.red)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}

extension FormView {
    @ViewBuilder func buttonView(
        text: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Text("")
                    .hidden()
                Spacer()
                Text(text)
                Spacer()
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(
            store: Store(
                initialState: FormState(),
                reducer: formReducer,
                environment: FormEnvironment(
                    save: { _ in return .none }
                )
            )
        )
    }
}
