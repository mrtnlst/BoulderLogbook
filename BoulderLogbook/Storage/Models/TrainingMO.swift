//
//  TrainingMO.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.10.25.
//

import CoreData

@objc(TrainingMO)
class TrainingMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var exercise: ExerciseMO
    @NSManaged public var result: ResultMO
}

extension TrainingMO {
    var toTraining: Training? {
        guard let result = result.toResult else {
            return nil
        }
        return Training(
            id: id,
            date: date,
            exercise: exercise.toExercise,
            result: result
        )
    }
}
