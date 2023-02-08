//
//  FilterSheetViewModel.swift
//  BoulderLogbook
//
//  Created by Martin List on 08.02.23.
//

import Foundation

struct FilterViewModel: Equatable, Identifiable {
    let id: UUID
    var grade: GradeSystem.Grade
    var isOn: Bool
    
    init(grade: GradeSystem.Grade, isOn: Bool) {
        self.id = grade.id
        self.grade = grade
        self.isOn = isOn
    }
}

extension FilterViewModel {
    static var samples: [FilterViewModel] {
        GradeSystem.mandala.grades.map { FilterViewModel(grade: $0, isOn: true) }
    }
}
