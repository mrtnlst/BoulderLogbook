//
//  FilterSheetState.swift
//  BoulderLogbook
//
//  Created by Martin List on 23.10.22.
//

import Foundation
import IdentifiedCollections

struct FilterSheetState: Equatable {
    var filters: IdentifiedArrayOf<FilterState> = IdentifiedArray(
        uniqueElements: BoulderGrade.allCases.map {
            FilterState(
                grade: $0,
                isOn: false
            )
        }
    )
}
