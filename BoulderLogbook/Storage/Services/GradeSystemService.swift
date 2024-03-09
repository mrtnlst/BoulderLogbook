//
//  GradeSystemService.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.02.24.
//

import CoreData

fileprivate extension String {
    static let gradeSystemsKey = "grade-systems"
    static let selectedGradeSystemKey = "selected-grade-system"
    static let defaultGradeSystems = "default-grade-systems"
}

final class GradeSystemService {
    private let storage: CoreDataStorage
    private let backgroundContext: NSManagedObjectContext
    private let defaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        storage: CoreDataStorage,
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

    func fetchAvailableSystems() async -> [GradeSystem] {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let gradeSystems: [GradeSystemMO] = storage.fetch(on: backgroundContext)
                continuation.resume(
                    returning: gradeSystems.map { $0.toGradeSystem(with: decoder) }
                )
            }
        }
    }

    func fetchSelectedSystem() async -> GradeSystem? {
        guard let encodedData = defaults.object(forKey: .selectedGradeSystemKey) as? Data,
              let decodedData = try? decoder.decode(UUID.self, from: encodedData) else {
            return nil
        }
        return await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                let gradeSystem: GradeSystemMO? = storage.fetch(
                    predicate: .init(
                        format: "%K == %@", #keyPath(GradeSystemMO.id), decodedData as NSUUID
                    ),
                    on: backgroundContext
                ).first
                continuation.resume(returning: gradeSystem?.toGradeSystem(with: decoder))
            }
        }
    }

    func saveSystem(_ system: GradeSystem) async {
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                if let gradeSystem: GradeSystemMO = storage.fetch(
                    predicate: .init(
                        format: "%K == %@", #keyPath(GradeSystemMO.id), system.id as NSUUID
                    ),
                    on: backgroundContext
                ).first {
                    storage.delete(object: gradeSystem, from: backgroundContext)
                }

                let newSystem: GradeSystemMO = storage.insert(into: backgroundContext)
                newSystem.id = system.id
                newSystem.name = system.name
                let grades = system.grades.compactMap { grade -> GradeMO? in
                    guard let color = try? encoder.encode(grade.color) else {
                        return nil
                    }
                    let gradeMO: GradeMO = storage.insert(into: backgroundContext)
                    gradeMO.id = grade.id
                    gradeMO.difficulty = NSNumber(value: grade.difficulty)
                    gradeMO.name = grade.name
                    gradeMO.color = color
                    return gradeMO
                }
                newSystem.grades = Set(grades)
                storage.save(on: backgroundContext)
                continuation.resume()
            }
        }
    }

    func saveSelectedSystem(for id: UUID) {
        let data = try? encoder.encode(id)
        defaults.set(data, forKey: .selectedGradeSystemKey)
    }

    func deleteSystem(for id: UUID) async {
        if let selectedSystem = await fetchSelectedSystem(), id == selectedSystem.id {
            defaults.set(nil, forKey: .selectedGradeSystemKey)
        }
        await withCheckedContinuation { continuation in
            backgroundContext.performAndWait {
                guard let system: GradeSystemMO = storage.fetch(
                    predicate: .init(
                        format: "%K == %@", #keyPath(GradeSystemMO.id), id as NSUUID
                    ),
                    on: backgroundContext
                ).first else {
                    continuation.resume()
                    return
                }
                storage.delete(object: system, from: backgroundContext)
                continuation.resume()
            }
        }
    }

    func saveDefaultSystems() async {
        guard !defaults.bool(forKey: .defaultGradeSystems) else {
            return
        }

        let availableSystems = await fetchAvailableSystems()
        guard !availableSystems.contains(where: { $0.id == GradeSystem.mandala.id }) else {
            return
        }
        await saveSystem(.mandala)
        defaults.set(true, forKey: .defaultGradeSystems)
    }

    func migrateGradeSystems() async {
        guard let encodedData = defaults.object(forKey: .gradeSystemsKey) as? Data,
              let decodedData = try? decoder.decode([GradeSystem].self, from: encodedData) else {
            return
        }
        let availableSystems = await fetchAvailableSystems()
        for gradeSystem in decodedData {
            if !availableSystems.contains(where: { $0.id == gradeSystem.id }) {
                await saveSystem(gradeSystem)
            }
        }
    }
}
