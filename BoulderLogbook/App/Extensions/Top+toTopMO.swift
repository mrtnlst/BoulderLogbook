//
//  Top+toTopMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.04.26.
//

import CoreData

extension Top {
    func toTopMO(into context: NSManagedObjectContext, entry: LogbookEntryMO) {
        let topMO: TopMO = TopMO(context: context)
        topMO.id = id
        topMO.grade = grade
        topMO.wasAttempt = isAttempt
        topMO.wasFlash = wasFlash
        topMO.wasOnsight = wasOnsight
        topMO.entry = entry
    }
}
