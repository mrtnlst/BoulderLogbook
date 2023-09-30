//
//  DashboardSection.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.01.23.
//

import Foundation
import ComposableArchitecture

struct DashboardSection: Reducer {
    struct State: Equatable, Identifiable {
        var id: Double { date.timeIntervalSince1970 }
        let date: Date
        @PresentationState var entryDetail: EntryDetail.State?
        var entryDetailStates: IdentifiedArrayOf<EntryDetail.State>
        var gradeSystems: [GradeSystem] = []
        
        init(
            date: Date,
            entries: [Logbook.Section.Entry],
            gradeSystems: [GradeSystem]
        ) {
            self.date = date
            self.gradeSystems = gradeSystems
            self.entryDetailStates = .init(uniqueElements: entries
                .compactMap { entry in
                    guard let system = gradeSystems.first(where: { $0.id == entry.gradeSystem }) else {
                        return nil
                    }
                    return EntryDetail.State(entry: entry, gradeSystem: system)
                }
                .sorted { $0.entry.date > $1.entry.date }
            )
        }
    }
    
    enum Action: Equatable {
        case delete(UUID)
        case deleteDidFinish(TaskResult<EntryClientResponse>)
        case edit(Logbook.Section.Entry)
        case entryDetail(PresentationAction<EntryDetail.Action>)
        case setNavigation(EntryDetail.State.ID)
        
        enum EntryClientResponse { case finished }
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.entryClient) var entryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .delete(id),
                 let .entryDetail(.presented(.delete(id))):
                return .run { send in
                    await send(
                        .deleteDidFinish(
                            TaskResult {
                                entryClient.deleteEntry(id)
                                return .finished
                            }
                        )
                    )
                }
                
            case .deleteDidFinish:
                state.entryDetail = nil
                
            case let .entryDetail(.presented(.edit(entry))):
                state.entryDetail = nil
                // Wait shortly after dismissing the detail view to avoid presenting
                // the modal view detached while still being on the `EntryDetailView`.
                return .run { send in
                    try await Task.sleep(for: .milliseconds(50))
                    await send(.edit(entry))
                }
                
            case let .setNavigation(id):
                state.entryDetail = state.entryDetailStates[id: id]
                
            default: ()
            }
            return .none
        }
        .ifLet(\.$entryDetail, action: /Action.entryDetail) {
            EntryDetail()
        }
    }
}
