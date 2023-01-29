//
//  GradeSystemList.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import ComposableArchitecture

struct GradeSystemList: ReducerProtocol {
    public struct State: Equatable {
        var gradeSystems: [GradeSystem] = [mandalaGrades, kletterarenaGrades]
        var selectedSystem: GradeSystem?
    }
    
    enum Action: Equatable {
        case onAppear
        case fetchAvailableSystems
        case fetchSelectedSystem
        case receiveAvailableSystems(TaskResult<[GradeSystem]>)
        case receiveSelectedSystem(TaskResult<GradeSystem>)
    }
    
    @Dependency(\.gradeSystemClient) var gradeSystemClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return .merge(
                .task { .fetchAvailableSystems },
                .task { .fetchSelectedSystem }
            )
            
        case .fetchAvailableSystems:
            return .task {
                await .receiveAvailableSystems(TaskResult { gradeSystemClient.fetchAvailableSystems() })
            }
     
        case .fetchSelectedSystem:
            return .none
            
        case let .receiveAvailableSystems(.success(gradeSystems)):
            state.gradeSystems = gradeSystems
            return .none
            
        case let .receiveSelectedSystem(.success(selectedSystem)):
            state.selectedSystem = selectedSystem
            return .none
            
        case .receiveAvailableSystems(.failure),
             .receiveSelectedSystem(.failure):
            return .none
        }
    }
}

