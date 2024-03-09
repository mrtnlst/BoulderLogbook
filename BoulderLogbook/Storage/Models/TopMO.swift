//
//  TopMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 06.03.24.
//

import CoreData

@objc(TopMO)
class TopMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var grade: UUID
    @NSManaged public var wasAttempt: Bool
    @NSManaged public var wasFlash: Bool
    @NSManaged public var wasOnsight: Bool
    @NSManaged public var entry: LogbookEntryMO
}

extension TopMO {
    func toTop() -> Top {
        Top(
            id: id,
            grade: grade,
            isAttempt: wasAttempt,
            wasFlash: wasFlash,
            wasOnsight: wasOnsight
        )
    }
}
