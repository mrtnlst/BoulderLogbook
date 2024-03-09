//
//  LogbookEntryMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.03.24.
//

import CoreData

@objc(LogbookEntryMO)
class LogbookEntryMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var notes: String?
    @NSManaged public var tops: Set<TopMO>
    @NSManaged public var gradeSystem: UUID
    @NSManaged public var section: LogbookSectionMO
}

extension LogbookEntryMO {
    func toLogbookEntry() -> Logbook.Section.Entry {
        .init(
            id: id,
            date: date,
            notes: notes,
            tops: tops.map {
                $0.toTop()
            },
            gradeSystem: gradeSystem
        )
    }
}
