//
//  KeypadKey.swift
//  BoulderLogbook
//
//  Created by Martin List on 11.10.26.
//

struct KeypadKey: Identifiable {
    let id: String
    let isSymbol: Bool
   
    init(id: String, isSymbol: Bool = false) {
        self.id = id
        self.isSymbol = isSymbol
    }
}

extension KeypadKey {
    static let deleteKey = Self(id: "delete.left", isSymbol: true)
    static let saveKey = Self(id: "checkmark", isSymbol: true)
    static let clearKey = Self(id: "trash", isSymbol: true)
}

extension KeypadKey: Equatable {}
