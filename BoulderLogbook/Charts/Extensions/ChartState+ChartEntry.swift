//
//  ChartState+ChartEntry.swift
//  BoulderLogbook
//
//  Created by Martin List on 01.10.22.
//

import Foundation

extension ChartState {
    struct ChartEntry: Identifiable {
        let id: UUID = UUID()
        var grade: BoulderGrade
        var date: String
        var count: Int
    }
}
