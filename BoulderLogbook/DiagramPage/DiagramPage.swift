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
        var topCountDiagram: TopCountDiagram.State?
        var filterSheet: FilterSheet.State?
        var isPresentingFilter: Bool = false
    }
    
    enum Action: Equatable {
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case setIsPresentingFilter(Bool)
        case topCountDiagram(TopCountDiagram.Action)
        case filterSheet(FilterSheet.Action)
    }
    @Dependency(\.filterClient) var filterClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
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
                    state.topCountDiagram = TopCountDiagram.State(
                        entries: state.entries,
                        gradeSystem: system
                    )
                }
                return .none
                
            case .receiveSelectedSystem(.success(.none)):
                state.topCountDiagram = nil
                return .none
             
            case let .setIsPresentingFilter(isPresenting):
                // TODO: Maybe move to Dashboard?
                let systems = state.gradeSystems
                state.filterSheet = isPresenting ? FilterSheet.State(gradeSystems: systems) : nil
                state.isPresentingFilter = isPresenting
                
                if isPresenting {
                    return .none
                }
                return .task { .fetchSelectedSystem }

            default:
                return .none
            }
        }
        .ifLet(\.filterSheet, action: /Action.filterSheet) {
            FilterSheet()
        }
        .ifLet(\.topCountDiagram, action: /Action.topCountDiagram) {
            TopCountDiagram()
        }
    }
}
