//
//  DiagramPage.swift
//  BoulderLogbook
//
//  Created by Martin List on 13.02.23.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DiagramPage {
    struct State: Equatable {
        var entries: [Logbook.Section.Entry] = []
        var gradeSystems: [GradeSystem] = []
        var selectedGradeSystem: GradeSystem.ID?
        
        var topCountDiagram = TopCountDiagram.State()
        var sessionDiagram = SessionDiagram.State()
        var summaryDiagram = SummaryDiagram.State(hasWeekFilter: true)
        
        @BindingState var selectedTab: Tab = .topCount
        
        enum Tab: Int, Hashable, CaseIterable {
            case topCount
            case session
            case summary
        }
    }
    
    enum Action: Equatable, BindableAction {
        case onAppear
        case receiveSelectedDiagram(TaskResult<Int?>)

        case fetchEntries
        case receiveEntries(TaskResult<[Logbook.Section.Entry]>)
        
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)

        case fetchGradeSystems
        case receiveGradeSystems(TaskResult<[GradeSystem]>)
        
        case topCountDiagram(TopCountDiagram.Action)
        case sessionDiagram(SessionDiagram.Action)
        case summaryDiagram(SummaryDiagram.Action)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.filterClient) var filterClient
    @Dependency(\.diagramPageClient) var diagramPageClient
    @Dependency(\.entryClient) var entryClient
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    var body: some Reducer<State, Action> {
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
            case .onAppear:
                return .merge(
                    .run { send in
                        await send(
                            .receiveSelectedDiagram(TaskResult { diagramPageClient.fetchSelectedDiagram() })
                        )
                    },
                    .send(.fetchEntries)
                )
                
            case let .receiveSelectedDiagram(.success(id)):
                state.selectedTab = .init(rawValue: id ?? 0) ?? .topCount
                
            case .fetchEntries:
                return .run { send in
                    await send(
                        .receiveEntries(TaskResult { entryClient.fetchEntries() })
                    )
                }
            
            case let .receiveEntries(.success(entries)):
                state.entries = entries
                return .merge(
                    .send(.fetchGradeSystems),
                    .send(.sessionDiagram(.receiveEntries(entries)))
                )
                
            case .fetchGradeSystems:
                return .run { send in
                    await send(
                        .receiveGradeSystems(TaskResult { gradeSystemClient.fetchAvailableSystems() })
                    )
                }
                
            case let .receiveGradeSystems(.success(gradeSystems)):
                state.gradeSystems = gradeSystems
                return .send(.fetchSelectedSystem)
            
            case .fetchSelectedSystem:
                return .run { send in
                    await send(
                        .receiveSelectedSystem(TaskResult { filterClient.fetchFilterSystem() })
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedGradeSystem = selected
                let gradeSystem = state.gradeSystems.first(where: { $0.id == selected })
                return .merge(
                    .send(.summaryDiagram(.receiveData(state.entries, gradeSystem))),
                    .send(.topCountDiagram(.receiveData(state.entries, gradeSystem)))
                )
                
            case .topCountDiagram(.fetchData):
                let gradeSystem = state.gradeSystems.first(where: { $0.id == state.selectedGradeSystem })
                return .send(.topCountDiagram(.receiveData(state.entries, gradeSystem)))
                
            case .binding(\.$selectedTab):
                return .run { [tab = state.selectedTab] _ in
                    diagramPageClient.saveSelectedDiagram(tab.rawValue)
                }
                
            default: ()
            }
            return .none
        }
    }
}
