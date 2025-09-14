//
//  EntryDetail.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EntryDetail {
    @ObservableState
    struct State: Equatable, Identifiable {
        let id: UUID
        let entry: Logbook.Section.Entry
        var gradeSystem: GradeSystem
        var summaryDiagram = SummaryDiagram.State()
        
        init(
            entry: Logbook.Section.Entry,
            gradeSystem: GradeSystem
        ) {
            self.id = entry.id
            self.entry = entry
            self.gradeSystem = gradeSystem
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case delete(UUID)
        case edit(Logbook.Section.Entry)
        case summaryDiagram(SummaryDiagram.Action)
    }
    
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Scope(state: \.summaryDiagram, action: \.summaryDiagram) {
            SummaryDiagram()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.summaryDiagram(.receiveData([state.entry], state.gradeSystem)))
                
            case .edit,
                 .delete :
                return .run { _ in await dismiss() }
                
            default: ()
            }
            return .none
        }
    }
}
