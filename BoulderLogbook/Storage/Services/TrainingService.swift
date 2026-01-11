//
//  TrainingService.swift
//  BoulderLogbook
//
//  Created by Martin List on 12.10.25.
//

import CoreData

final class TrainingService {
    private let storage: CoreDataStorageType
    private let backgroundContext: NSManagedObjectContext
    private let defaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        storage: CoreDataStorageType,
        backgroundContext: NSManagedObjectContext,
        defaults: UserDefaults = .standard,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.defaults = defaults
        self.decoder = decoder
        self.encoder = encoder
        self.backgroundContext = backgroundContext
    }
    
    func fetchExercises() async -> [Exercise] {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let exercises: [ExerciseMO] = storage.fetch(on: backgroundContext)
                continuation.resume(
                    returning: exercises
                        .map { $0.toExercise }
                )
            }
        }
    }
    
    func saveExercise(_ exercise: Exercise) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                if let storedExercise = fetchExerciseMO(from: exercise.id) {
                    storedExercise.name = exercise.name
                    storedExercise.symbol = exercise.symbol
                } else {
                    let newExercise: ExerciseMO = storage.insert(into: backgroundContext)
                    newExercise.id = exercise.id
                    newExercise.name = exercise.name
                    newExercise.symbol = exercise.symbol
                }
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }
    
    func deleteExercise(for id: UUID) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                guard let exercise = fetchExerciseMO(from: id) else {
                    continuation.resume()
                    return
                }
                storage.delete(object: exercise, from: backgroundContext)
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }
    
    func fetchTrainings() async -> [Training] {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let trainings: [TrainingMO] = storage.fetch(on: backgroundContext)
                continuation.resume(
                    returning: trainings.compactMap {
                        $0.toTraining
                    }
                )
            }
        }
    }
    
    func saveTraining(_ training: Training) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                if let storedTraining: TrainingMO = storage.fetch(
                    predicate: .init(
                        format: "%K == %@", #keyPath(TrainingMO.id), training.id as NSUUID
                    ),
                    on: backgroundContext
                ).first {
                    storedTraining.date = training.date
                    storedTraining.exercise.id = training.exercise.id
                    storedTraining.exercise.name = training.exercise.name
                    storedTraining.exercise.symbol = training.exercise.symbol
                    
                    switch training.result {
                    case let .duration(value):
                        storedTraining.result.duration = NSNumber(value: value)
                    case let .repititions(value):
                        storedTraining.result.repititions = NSNumber(value: value)
                    }
                } else {
                    let newTraining: TrainingMO = storage.insert(into: backgroundContext)
                    newTraining.id = training.id
                    newTraining.date = training.date
                    
                    if let exerciseMO = fetchExerciseMO(from: training.exercise.id) {
                        newTraining.exercise = exerciseMO
                    }
                    
                    let result: ResultMO = storage.insert(into: backgroundContext)
                    switch training.result {
                    case let .duration(value):
                        result.duration = NSNumber(value: value)
                    case let .repititions(value):
                        result.repititions = NSNumber(value: value)
                    }
                    newTraining.result = result
                }
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }
    
    func deleteTraining(for id: UUID) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                guard let training = fetchTrainingMO(from: id) else {
                    continuation.resume()
                    return
                }
                storage.delete(object: training, from: backgroundContext)
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }
}

private extension TrainingService {
    func fetchExerciseMO(from id: UUID) -> ExerciseMO? {
        let exercise: ExerciseMO? = storage.fetch(
            predicate: .init(
                format: "%K == %@", #keyPath(ExerciseMO.id), id as NSUUID
            ),
            on: backgroundContext
        ).first
        return exercise
    }
    
    func fetchTrainingMO(from id: UUID) -> TrainingMO? {
        let training: TrainingMO? = storage.fetch(
            predicate: .init(
                format: "%K == %@", #keyPath(TrainingMO.id), id as NSUUID
            ),
            on: backgroundContext
        ).first
        return training
    }
}
