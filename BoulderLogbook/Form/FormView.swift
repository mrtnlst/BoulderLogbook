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
                    Text("Enter the number of finished boulders!")
                }
                Section {
                    ForEach(BoulderGrade.allCases, id: \.self) { grade in
                        Stepper {
                            HStack {
                                Image(systemName: grade == .white ? "circle" : "circle.fill")
                                    .foregroundColor(grade == .white ? .none : grade.color)
                                Text("× \(viewStore.logbookEntry?.numberOfGrades(for: grade) ?? 0)")
                            }
                        } onIncrement: {
                            viewStore.send(.increase(grade))
                        } onDecrement: {
                            viewStore.send(.decrease(grade))
                        }
                    }
                }
                Section {
                    buttonView(text: "Save") { viewStore.send(.save) }
                        .foregroundColor(.green)
                    buttonView(text: "Cancel") { viewStore.send(.cancel) }
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

extension FormView {
    @ViewBuilder func buttonView(text: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(text)
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
