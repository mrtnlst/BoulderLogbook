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
    @ObservableState
    struct State: Equatable {
        var entries: [Logbook.Section.Entry] = []
        var gradeSystems: [GradeSystem] = []
        var selectedGradeSystem: GradeSystem?
        
        var topCountDiagram = TopCountDiagram.State()
        var sessionDiagram = SessionDiagram.State()
        var summaryDiagram = SummaryDiagram.State()
        
        var selectedTab: Tab = .topCount
        
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
        case receiveSelectedSystem(TaskResult<GradeSystem?>)
        case topCountDiagram(TopCountDiagram.Action)
        case sessionDiagram(SessionDiagram.Action)
        case summaryDiagram(SummaryDiagram.Action)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.diagramPageClient) var diagramPageClient
    @Dependency(LogbookEntryClient.self) var entryClient
    @Dependency(GradeSystemClient.self) var gradeSystemClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.topCountDiagram, action: \.topCountDiagram) {
            TopCountDiagram()
        }
        Scope(state: \.sessionDiagram, action: \.sessionDiagram) {
            SessionDiagram()
        }
        Scope(state: \.summaryDiagram, action: \.summaryDiagram) {
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
                        .receiveEntries(TaskResult { await entryClient.fetchEntries() })
                    )
                }
            
            case let .receiveEntries(.success(entries)):
                state.entries = entries
                return .merge(
                    .send(.fetchSelectedSystem),
                    .send(.sessionDiagram(.receiveEntries(entries)))
                )

            case .fetchSelectedSystem:
                return .run { send in
                    await send(
                        .receiveSelectedSystem(TaskResult { await gradeSystemClient.fetchSelectedSystem() })
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedGradeSystem = selected
                return .merge(
                    .send(.summaryDiagram(.receiveData(state.entries, selected))),
                    .send(.topCountDiagram(.receiveData(state.entries, selected)))
                )
                
            case .topCountDiagram(.fetchData):
                return .send(.topCountDiagram(.receiveData(state.entries, state.selectedGradeSystem)))
                
            case .binding(\.selectedTab):
                return .run { [tab = state.selectedTab] _ in
                    diagramPageClient.saveSelectedDiagram(tab.rawValue)
                }
                
            default: ()
            }
            return .none
        }
    }
}
