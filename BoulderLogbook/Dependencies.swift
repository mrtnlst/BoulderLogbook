//
//  Dependencies.swift
//  BoulderLogbook
//
//  Created by Martin List on 27.02.24.
//

import Foundation

struct Dependencies {
    let storage = CoreDataStorage.shared
    let gradeSystemService: GradeSystemService
    let logbookEntryService: LogbookEntryService
    let trainingService: TrainingService

    init() {
        let sessionContext = storage.storeContainer.newBackgroundContext()
        self.gradeSystemService = GradeSystemService(
            storage: storage,
            backgroundContext: sessionContext
        )
        self.logbookEntryService = LogbookEntryService(
            storage: storage,
            backgroundContext: sessionContext
        )
        let trainingContext = storage.storeContainer.newBackgroundContext()
        self.trainingService = TrainingService(
            storage: storage,
            backgroundContext: trainingContext
        )
    }
}
