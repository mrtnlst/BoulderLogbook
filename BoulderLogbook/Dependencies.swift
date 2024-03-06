//
//  Dependencies.swift
//  BoulderLogbook
//
//  Created by Martin List on 27.02.24.
//

import Foundation

struct Dependencies {
    let storage = CoreDataStorage()
    let gradeSystemService: GradeSystemService

    init() {
        self.gradeSystemService = GradeSystemService(storage: storage)
    }
}
