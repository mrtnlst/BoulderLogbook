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

    init() {
        let backgroundContext = storage.storeContainer.newBackgroundContext()
        self.gradeSystemService = GradeSystemService(storage: storage, backgroundContext: backgroundContext)
        self.logbookEntryService = LogbookEntryService(storage: storage, backgroundContext: backgroundContext)
    }
}
