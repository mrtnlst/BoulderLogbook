//
//  Collection+safe.swift
//  BoulderLogbook
//
//  Created by Martin List on 30.01.23.
//
// https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
