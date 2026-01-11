//
//  ExerciseMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.10.25.
//

import CoreData

@objc(ExerciseMO)
class ExerciseMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var symbol: String
}

extension ExerciseMO {
    var toExercise: Exercise {
        Exercise(id: id, name: name, symbol: symbol)
    }
}
