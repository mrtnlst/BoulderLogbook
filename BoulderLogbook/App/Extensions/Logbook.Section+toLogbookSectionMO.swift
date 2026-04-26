//
//  Logbook.Section+toLogbookSectionMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.04.26.
//

import CoreData

extension Logbook.Section {
    func toLogbookSectionMO(into context: NSManagedObjectContext) -> LogbookSectionMO {
        let sectionMO: LogbookSectionMO = LogbookSectionMO(context: context)
        sectionMO.date = date
        for entry in entries {
            let entryMO = entry.toLogbookEntryMO(into: context)
            entryMO.section = sectionMO
        }
        return sectionMO
    }
}

