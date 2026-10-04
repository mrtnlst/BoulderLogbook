//
//  GradeSystemList.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GradeSystemList {
    @Reducer
    enum Destination {
        case gradeSystemForm(GradeSystemForm)
        case confirmationDialog(AlertState<Confirmation>)
        
        @CasePathable
        enum Confirmation {
            case delete
        }
    }
    
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        @Shared var gradeSystems: [GradeSystem]
        @Shared(.fileStorage(.focusGrade)) var focusedGrade: Grade?
        @Shared(.fileStorage(.defaultGradeSystem)) var defaultGradeSystem: GradeSystem?
        var systemToDelete: GradeSystem?
        
        init(gradeSystems: Shared<[GradeSystem]>) {
            self._gradeSystems = gradeSystems
        }
    }
    
    enum Action: ViewAction {
        enum Delegate {
            case fetchGradeSystems
        }
        enum View {
            case presentGradeSystemForm
            case setSystemToDelete(GradeSystem)
            case edit(UUID)
        }
        case presentConfirmation
        case saveSelected(GradeSystem)
        case delete(UUID)
        case setFocusGrade(Grade?)
        case delegate(Delegate)
        case view(View)
        case destination(PresentationAction<Destination.Action>)
    }
    
    @Dependency(\.gradeSystemClient) var client
    @Dependency(\.logbookEntryClient) var entryClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.presentGradeSystemForm):
                state.destination = .gradeSystemForm(GradeSystemForm.State())
                
            case .presentConfirmation:
                let name = state.systemToDelete?.name ?? ""
                state.destination = .confirmationDialog(
                    AlertState {
                        TextState("Warning")
                    } actions: {
                        ButtonState(role: .destructive, action: .delete) {
                            TextState("Delete")
                        }
                    } message: {
                        TextState("Deleting \(name) removes all of its logbook entries!")
                    }
                )
                
            case let .saveSelected(selected):
                guard state.defaultGradeSystem != selected else {
                    return .none
                }
                state.$defaultGradeSystem.withLock {
                    $0 = selected
                }

            case let .view(.setSystemToDelete(system)):
                state.systemToDelete = system
                return .send(.presentConfirmation)
                
            case .destination(.presented(.confirmationDialog(.delete))):
                guard let systemToDelete = state.systemToDelete else {
                    return .none
                }
                return .send(.delete(systemToDelete.id))
                
            case let .delete(id):
                if state.defaultGradeSystem?.id == id {
                    state.$defaultGradeSystem.withLock {
                        $0 = nil
                    }
                    // Focus Grade is taken from default system.
                    state.$focusedGrade.withLock {
                        $0 = nil
                    }
                }
                return .concatenate(
                    .run { _ in
                        await client.deleteSystem(id)
                        await entryClient.deleteEntries(id)
                    },
                    .send(.delegate(.fetchGradeSystems))
                )
            
            case let .setFocusGrade(grade):
                state.$focusedGrade.withLock {
                    $0 = grade
                }
                
            case let .view(.edit(id)):
                guard let gradeSystem = state.gradeSystems.first (where: { $0.id == id }) else {
                    return .none
                }
                let formState = GradeSystemForm.State(
                    id: gradeSystem.id,
                    name: gradeSystem.name,
                    grades: gradeSystem.grades
                )
                state.destination = .gradeSystemForm(formState)
                
            case .destination(.presented(.gradeSystemForm(.cancel))):
                state.destination = nil
                
            case .destination(.presented(.gradeSystemForm(.saveDidFinish))):
                state.destination = nil
                return .send(.delegate(.fetchGradeSystems))

            default: ()
            }
            return .none
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
