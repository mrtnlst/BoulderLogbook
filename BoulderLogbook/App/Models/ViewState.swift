//
//  ViewState.swift
//  BoulderLogbook
//
//  Created by Martin List on 02.07.23.
//

enum ViewState<T: Equatable, E: Equatable>: Equatable {
    case loading
    case idle(T)
    case empty(E? = nil)
}
