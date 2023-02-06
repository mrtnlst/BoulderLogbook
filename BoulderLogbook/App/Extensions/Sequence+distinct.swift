//
//  Sequence+distinct.swift
//  BoulderLogbook
//
//  Created by Martin List on 05.02.23.
//
// https://stackoverflow.com/a/71681339/8849267

import Foundation

extension Sequence {
    func distinct<Type: Hashable>(by keyPath: KeyPath<Element, Type>) -> [Element] {
        var set = Set<Type>()
        return filter { set.insert($0[keyPath: keyPath]).inserted }
    }
}
