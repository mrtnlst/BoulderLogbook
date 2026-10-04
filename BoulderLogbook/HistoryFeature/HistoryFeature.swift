//
//  HistoryFeature.swift
//  BoulderLogbook
//
//  Created by Martin List on 04.10.26.
//

import ComposableArchitecture

@Reducer
struct HistoryFeature {
    @Reducer
    enum Destination {
        case entryForm(EntryForm)
        case entryDetail(EntryDetail)
        case confirmationDialog(AlertState<Confirmation>)

        @CasePathable
        enum Confirmation {
            case delete
        }
    }

    @ObservableState
    struct State {
        var trends: TrendsFeature.State
        @Presents var destination: Destination.State?
        @Shared var sections: [Logbook.Section]
        @Shared var gradeSystems: [GradeSystem]
        @Shared(.fileStorage(.defaultGradeSystem)) var defaultGradeSystem: GradeSystem?
        @Shared(.fileStorage(.focusGrade)) var focusGrade: Grade?
        
        var entryToDelete: Logbook.Section.Entry.ID?

        var numberOfEntries: Int {
            sections.entries.count
        }
        
        init(
            sections: Shared<[Logbook.Section]>,
            gradeSystems: Shared<[GradeSystem]>
        ) {
            self._sections = sections
            self._gradeSystems = gradeSystems
            self.trends = .init(sections: sections)
        }
    }
    
    enum Action: ViewAction {
        enum Delegate {
            case fetchSections
        }
        enum View {
            case setNavigation(Logbook.Section.Entry)
            case delete(Logbook.Section.Entry.ID)
            case edit(Logbook.Section.Entry)
        }
        case showDeletionConfirmation
        case deleteDidFinish(TaskResult<EntryClientResponse>)
        case presentEntryForm(EntryForm.State?)
        case trends(TrendsFeature.Action)
        case view(View)
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        
        enum EntryClientResponse { case finished }
    }
    @Dependency(\.logbookEntryClient) var logbookEntryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        Scope(state: \.trends, action: \.trends) {
            TrendsFeature()
        }
        Reduce { state, action in
            switch action {
            case let .view(.delete(id)),
                 let .destination(.presented(.entryDetail(.delete(id)))) :
                state.entryToDelete = id
                return .run { send in
                    try await Task.sleep(for: .milliseconds(100))
                    await send(.showDeletionConfirmation)
                }

            case .showDeletionConfirmation:
                state.destination = .confirmationDialog(
                    AlertState {
                        TextState("Warning")
                    } actions: {
                        ButtonState(role: .destructive, action: .delete) {
                            TextState("Delete")
                        }
                    } message: {
                        TextState("Are you sure you want to delete this entry?")
                    }
                )

            case .destination(.presented(.confirmationDialog(.delete))):
                guard let entryToDelete = state.entryToDelete else {
                    return .none
                }
                return .run { send in
                    await send(
                        .deleteDidFinish(
                            TaskResult {
                                await logbookEntryClient.deleteEntry(entryToDelete)
                                return .finished
                            }
                        )
                    )
                }

            case .deleteDidFinish:
                state.destination = nil
                return .send(.delegate(.fetchSections))

            case let .view(.setNavigation(entry)):
                if let system = state.gradeSystems.first(where: { $0.id == entry.gradeSystem }) {
                    state.destination = .entryDetail(
                        EntryDetail.State(
                            entry: entry,
                            gradeSystem: system
                        )
                    )
                }
            case let .presentEntryForm(entryFormState):
                state.destination = .entryForm(entryFormState ?? EntryForm.State())

            case .destination(.presented(.entryForm(.cancel))):
                state.destination = nil
                
            case .destination(.presented(.entryForm(.saveDidFinish))):
                state.destination = nil
                return .send(.delegate(.fetchSections))
                
            case let .view(.edit(entry)),
                let .destination(.presented(.entryDetail(.edit(entry)))):
                return .run { send in
                    try await Task.sleep(for: .milliseconds(100))
                    await send(
                        .presentEntryForm(
                            .init(
                                id: entry.id,
                                date: entry.date,
                                notes: entry.notes,
                                tops: entry.tops.normal(),
                                attempts: entry.tops.filter { $0.isAttempt },
                                flashs: entry.tops.filter { $0.wasFlash },
                                onsights: entry.tops.filter { $0.wasOnsight },
                                selectedSystem: entry.gradeSystem,
                                isEditing: true
                            )
                        )
                    )
                }

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
