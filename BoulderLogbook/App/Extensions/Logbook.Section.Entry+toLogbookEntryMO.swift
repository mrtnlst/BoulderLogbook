//
//  Logbook.Section.Entry+toLogbookEntryMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.04.26.
//

import CoreData

extension Logbook.Section.Entry {
    func toLogbookEntryMO(into context: NSManagedObjectContext) -> LogbookEntryMO {
        let entryMO: LogbookEntryMO = LogbookEntryMO(context: context)
        entryMO.id = id
        entryMO.date = date
        entryMO.notes = notes
        entryMO.gradeSystem = gradeSystem
        tops.forEach { top in
            top.toTopMO(into: context, entry: entryMO)
        }
        return entryMO
    }
}
