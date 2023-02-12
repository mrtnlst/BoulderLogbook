//
//  DashboardSection.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct DashboardSection: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: Double { date.timeIntervalSince1970 }
        let date: Date
        var entryStates: IdentifiedArrayOf<EntryDetail.State> = []
        var gradeSystems: [GradeSystem] = []
        
        init(
            date: Date,
            entries: [Logbook.Section.Entry],
            gradeSystems: [GradeSystem]
        ) {
            self.date = date
            self.gradeSystems = gradeSystems
            
            let entryStates: [EntryDetail.State] = entries.compactMap { entry in
                guard let system = gradeSystems.first(where: { $0.id == entry.gradeSystem }) else {
                    return nil
                }
                return EntryDetail.State(entry: entry, gradeSystem: system)
            }
            self.entryStates = .init(uniqueElements: entryStates.sorted { $0.entry.date > $1.entry.date })
        }
    }
    
    enum Action: Equatable {
        case delete(UUID)
        case deleteDidFinish(TaskResult<EntryClientResponse>)
        case edit(Logbook.Section.Entry)
        case entryDetail(id: UUID, action: EntryDetail.Action)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.entryClient) var entryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .delete(id),
                 let .entryDetail(id: _, action: .delete(id)):
                return .task {
                    await .deleteDidFinish(
                        TaskResult {
                            entryClient.deleteEntry(id)
                            return .finished
                        }
                    )
                }
                
            default:
                return .none
            }
        }
        .forEach(\.entryStates, action: /Action.entryDetail) {
            EntryDetail()
        }
    }
}
