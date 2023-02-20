//
//  DiagramPage.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.02.23.
//

import Foundation
import ComposableArchitecture

struct DiagramPage: ReducerProtocol {
    struct State: Equatable {
        var entries: [Logbook.Section.Entry] = []
        var gradeSystems: [GradeSystem] = []
        var topCountDiagram = TopCountDiagram.State()
        var sessionDiagram = SessionDiagram.State()
        
        init(
            entries: [Logbook.Section.Entry] = [],
            gradeSystems: [GradeSystem] = []
        ) {
            self.entries = entries
            self.topCountDiagram.entries = entries
            self.sessionDiagram.entries = entries
            self.gradeSystems = gradeSystems
        
            // This is primarily used for Xcode Previews.
            if gradeSystems.count > 0 {
                self.topCountDiagram.gradeSystem = gradeSystems[0]
            }
        }
    }
    
    enum Action: Equatable {
        case receiveGradeSystems([GradeSystem])
        case receiveEntries([Logbook.Section.Entry])
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case presentFilters
        case topCountDiagram(TopCountDiagram.Action)
        case sessionDiagram(SessionDiagram.Action)
    }
    @Dependency(\.filterClient) var filterClient
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.topCountDiagram, action: /Action.topCountDiagram) {
            TopCountDiagram()
        }
        Scope(state: \.sessionDiagram, action: /Action.sessionDiagram) {
            SessionDiagram()
        }
        
        Reduce { state, action in
            switch action {
            case let .receiveGradeSystems(gradeSystems):
                state.gradeSystems = gradeSystems
                return .none
              
            case let .receiveEntries(entries):
                state.entries = entries
                state.sessionDiagram = SessionDiagram.State(entries: entries)
                return .task { .fetchSelectedSystem }
                  
            case .fetchSelectedSystem:
                return .task {
                    await .receiveSelectedSystem(
                        TaskResult {
                            filterClient.fetchFilterSystem()
                        }
                    )
                }
                
            case let .receiveSelectedSystem(.success(.some(selected))):
                if let system = state.gradeSystems.first(where: { $0.id == selected }) {
                    state.topCountDiagram.gradeSystem = system
                    state.topCountDiagram.entries = state.entries
                }
                return .none
                
            case .receiveSelectedSystem(.success(.none)):
                state.topCountDiagram.gradeSystem = nil
                state.topCountDiagram.entries = []
                return .none

            default:
                return .none
            }
        }
    }
}
