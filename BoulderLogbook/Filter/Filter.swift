//
//  Filter.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.01.23.
//

import Foundation
import ComposableArchitecture

struct Filter: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: UUID = UUID()
        var grade: BoulderGrade
        var isOn: Bool
    }
    
    enum Action {
        case fetch
        case receiveValue(Result<Bool, Never>)
        case setIsOn(Bool)
    }
    
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.storageService) var storageService
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetch:
            return storageService
                .fetch(filterKey: state.grade.gradeDescription)
                .receive(on: mainQueue)
                .catchToEffect(Action.receiveValue)
            
        case let .receiveValue(.success(value)):
            state.isOn = value
            return .none
            
        case let .setIsOn(isOn):
            state.isOn = isOn
            return storageService
                .save(value: isOn, for: state.grade.gradeDescription)
                .fireAndForget()
        }
    }
}
