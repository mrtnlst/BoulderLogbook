//
//  Dependencies.swift
//  BoulderLogbook
//
//  Created by Martin List on 27.02.24.
//

import Foundation
import Sharing

struct Dependencies {
    let storage = CoreDataStorage.shared
    let gradeSystemService: GradeSystemService
    let logbookEntryService: LogbookEntryService
    @Shared(.fileStorage(.defaultGradeSystem)) var defaultGradeSystem: GradeSystem?

    init() {
        let backgroundContext = storage.storeContainer.newBackgroundContext()
        self.gradeSystemService = GradeSystemService(storage: storage, backgroundContext: backgroundContext)
        self.logbookEntryService = LogbookEntryService(storage: storage, backgroundContext: backgroundContext)
    }
    
    func migrate() async {
        let selectedSystem = await self.gradeSystemService.fetchSelectedSystem()
        if defaultGradeSystem == nil, selectedSystem != nil {
            $defaultGradeSystem.withLock {
                $0 = selectedSystem
            }
        }
    }
}
