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
        var summaryDiagram = SummaryDiagram.State()
        
        @BindingState var selectedTab: Int = 0
        
        init(
            entries: [Logbook.Section.Entry] = [],
            gradeSystems: [GradeSystem] = []
        ) {
            self.entries = entries
            self.topCountDiagram.entries = entries
            self.sessionDiagram.entries = entries
            self.summaryDiagram.entries = entries
            self.gradeSystems = gradeSystems
        
            // This is primarily used for Xcode Previews.
            if gradeSystems.count > 0 {
                self.topCountDiagram.gradeSystem = gradeSystems[0]
                self.summaryDiagram.gradeSystem = gradeSystems[0]
            }
        }
    }
    
    enum Action: Equatable, BindableAction {
        case task
        case receiveSelectedDiagram(TaskResult<Int?>)
        case receiveGradeSystems([GradeSystem])
        case receiveEntries([Logbook.Section.Entry])
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case topCountDiagram(TopCountDiagram.Action)
        case sessionDiagram(SessionDiagram.Action)
        case summaryDiagram(SummaryDiagram.Action)
        case binding(BindingAction<State>)
    }
    @Dependency(\.filterClient) var filterClient
    @Dependency(\.diagramPageClient) var diagramPageClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Scope(state: \.topCountDiagram, action: /Action.topCountDiagram) {
            TopCountDiagram()
        }
        Scope(state: \.sessionDiagram, action: /Action.sessionDiagram) {
            SessionDiagram()
        }
        Scope(state: \.summaryDiagram, action: /Action.summaryDiagram) {
            SummaryDiagram()
        }
        Reduce { state, action in
            switch action {
            case .task:
                return .task {
                    await .receiveSelectedDiagram(
                        TaskResult {
                            diagramPageClient.fetchSelectedDiagram()
                        }
                    )
                }
                
            case let .receiveSelectedDiagram(.success(id)):
                state.selectedTab = id ?? 0
            
            case let .receiveGradeSystems(gradeSystems):
                state.gradeSystems = gradeSystems
              
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
                    state.summaryDiagram.entries = state.entries
                    state.summaryDiagram.gradeSystem = system
                }
                
            case .receiveSelectedSystem(.success(.none)):
                state.topCountDiagram.gradeSystem = nil
                state.topCountDiagram.entries = []
                state.summaryDiagram.gradeSystem = nil
                state.summaryDiagram.entries = []

            case .binding(\.$selectedTab):
                let id = state.selectedTab
                return .fireAndForget {
                    diagramPageClient.saveSelectedDiagram(id)
                }
                
            default: ()
            }
            return .none
        }
    }
}
