//
//  LogbookSectionMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.03.24.
//

import CoreData

@objc(LogbookSectionMO)
class LogbookSectionMO: NSManagedObject {
    @NSManaged public var date: Date
    @NSManaged public var entries: Set<LogbookEntryMO>
}

extension LogbookSectionMO {
    func toLogbookSection() -> Logbook.Section {
        .init(
            date: date,
            entries: entries
                .map { $0.toLogbookEntry() }
                .sorted(by: { $0.date > $1.date })
        )
    }
}
