//
//  HorizontalSelectionElement.swift
//  BoulderLogbook
//
//  Created by Martin List on 10.10.26.
//

import Foundation

protocol HorizontalSelectionElement: Sendable, Hashable, Identifiable, Equatable where ID == UUID {
    var name: String { get }
}
