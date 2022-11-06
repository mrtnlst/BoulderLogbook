//
//  FilterState.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import Foundation

struct FilterState: Equatable, Identifiable {
    var id: UUID = UUID()
    var grade: BoulderGrade
    var isOn: Bool
}
