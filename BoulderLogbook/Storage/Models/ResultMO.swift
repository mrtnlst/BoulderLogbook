//
//  ResultMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.10.25.
//

import CoreData

@objc(ResultMO)
class ResultMO: NSManagedObject {
    @NSManaged public var duration: NSNumber?
    @NSManaged public var repititions: NSNumber?
}

extension ResultMO {
    var toResult: Training.Result? {
        if let duration = duration?.doubleValue, !duration.isZero {
            return .duration(duration)
        } else if let repititions = repititions?.int64Value {
            return .repititions(Int(repititions))
        } else {
            return nil
        }
    }
}
