//
//  FilterAction.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import Foundation

enum FilterAction {
    case fetch
    case receiveValue(Result<Bool, Never>)
    case setIsOn(Bool)
}
