//
//  GradeMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.02.24.
//

import CoreData
import SwiftUI

@objc(GradeMO)
class GradeMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var color: Data
    @NSManaged public var difficulty: NSNumber
}

extension GradeMO {
    func toGrade(with color: Color) -> Grade {
        Grade(
            id: id,
            name: name,
            color: color,
            difficulty: Int(truncating: difficulty)
        )
    }
}
