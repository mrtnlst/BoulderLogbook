//
//  FilterSheet.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.01.23.
//

import Foundation
import ComposableArchitecture

struct FilterSheet: ReducerProtocol {
    struct State: Equatable {
        var gradeSystems: [GradeSystem] = []
        @BindingState var selectedSystemId: UUID?
        @BindingState var filters: [FilterViewModel] = []
        
        var selectedSystem: GradeSystem? {
            gradeSystems.first(where: { $0.id == selectedSystemId })
        }
    }
    
    enum Action: BindableAction {
        case onAppear
        case fetchSelectedSystem
        case receiveSelectedSystem(TaskResult<UUID?>)
        case fetchFilters
        case receiveFilters(TaskResult<[Filter]?>)
        case saveFilters
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.filterClient) var filterClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .task { .fetchSelectedSystem }
                
            case .fetchSelectedSystem:
                return .task {
                    await .receiveSelectedSystem(
                        TaskResult { filterClient.fetchFilterSystem() }
                    )
                }
                
            case let .receiveSelectedSystem(.success(selected)):
                state.selectedSystemId = selected
                return .task { .fetchFilters }
                
            case .fetchFilters:
                return .task {
                    await .receiveFilters(
                        TaskResult { filterClient.fetchFilters() }
                    )
                }
                
            case let .receiveFilters(.success(filters)):
                guard let filters = filters, let filterSystem = state.selectedSystem else {
                    return .none
                }
                var availableFilters = filters.compactMap { filter in
                    if let grade = filterSystem.grades.first(where: { $0.id == filter.id }) {
                        return FilterViewModel(grade: grade, isOn: filter.isOn)
                    }
                    return nil
                }
                if availableFilters.isEmpty {
                    availableFilters = filterSystem.grades.map { FilterViewModel(grade: $0, isOn: true) }
                    state.filters = availableFilters
                    return .task { .saveFilters }
                }
                state.filters = availableFilters
                return .none
                
            case .saveFilters:
                let currentFilters = state.filters.map { Filter(id: $0.id, isOn: $0.isOn) }
                return .fireAndForget { filterClient.saveFilters(currentFilters) }
                
            case .binding(\.$selectedSystemId):
                var effects: [EffectPublisher<Action, Never>] = [
                    .fireAndForget { [state] in
                        filterClient.saveFilterSystem(state.selectedSystemId)
                        
                    }
                ]
                if state.selectedSystemId == nil {
                    state.filters.removeAll()
                    effects.append(.task { .saveFilters })
                }
                effects.append(
                    .task { .receiveFilters(.success([])) }
                )
                return .merge(effects)
                
            case .binding(\.$filters):
                return .task { .saveFilters }
            
            default:
                return .none
            }
        }
    }
}
