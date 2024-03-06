//
//  GradeSystemService.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.02.24.
//

import SwiftUI

fileprivate extension String {
    static let gradeSystemsKey = "grade-systems"
    static let selectedGradeSystemKey = "selected-grade-system"
    static let defaultGradeSystems = "default-grade-systems"
}

final class GradeSystemService {
    let storage: CoreDataStorage
    let defaults: UserDefaults
    let decoder: JSONDecoder
    let encoder: JSONEncoder

    init(
        storage: CoreDataStorage,
        defaults: UserDefaults = .standard,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.defaults = defaults
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetchAvailableSystems() -> [GradeSystem] {
        let gradeSystems: [GradeSystemMO] = storage.fetch()
        return gradeSystems.map { $0.toGradeSystem(with: decoder) }
    }

    func fetchSelectedSystem() -> GradeSystem? {
        guard let encodedData = defaults.object(forKey: .selectedGradeSystemKey) as? Data,
              let decodedData = try? decoder.decode(UUID.self, from: encodedData) else {
            return nil
        }

        let gradeSystem: GradeSystemMO? = storage.fetch(
            predicate: .init(
                format: "%K == %@", #keyPath(GradeSystemMO.id), decodedData as NSUUID
            )
        ).first
        return gradeSystem?.toGradeSystem(with: decoder)
    }

    func saveSystem(_ system: GradeSystem) {
        if let gradeSystem: GradeSystemMO = storage.fetch(
            predicate: .init(
                format: "%K == %@", #keyPath(GradeSystemMO.id), system.id as NSUUID
            )
        ).first {
            storage.delete(object: gradeSystem)
        }

        let newSystem: GradeSystemMO = storage.insert()
        newSystem.id = system.id
        newSystem.name = system.name
        let grades = system.grades.compactMap { grade -> GradeMO? in
            guard let color = try? encoder.encode(grade.color) else {
                return nil
            }
            let gradeMO: GradeMO = storage.insert()
            gradeMO.id = grade.id
            gradeMO.difficulty = NSNumber(value: grade.difficulty)
            gradeMO.name = grade.name
            gradeMO.color = color
            return gradeMO
        }
        newSystem.grades = Set(grades)
        storage.save()
    }

    func saveSelectedSystem(for id: UUID) {
        let data = try? encoder.encode(id)
        defaults.set(data, forKey: .selectedGradeSystemKey)
    }

    func deleteSystem(for id: UUID) {
        guard let system: GradeSystemMO = storage.fetch(
            predicate: .init(
                format: "%K == %@", #keyPath(GradeSystemMO.id), id as NSUUID
            )
        ).first else {
            return
        }
        storage.delete(object: system)

        if let selectedSystem = fetchSelectedSystem(), id == selectedSystem.id {
            defaults.set(nil, forKey: .selectedGradeSystemKey)
        }
    }

    func saveDefaultSystems() {
        guard !defaults.bool(forKey: .defaultGradeSystems) else {
            return
        }

        let availableSystems = fetchAvailableSystems()
        guard !availableSystems.contains(where: { $0.id == GradeSystem.mandala.id }) else {
            return
        }
        saveSystem(.mandala)
        defaults.set(true, forKey: .defaultGradeSystems)
    }

    func migrateGradeSystems() {
        guard let encodedData = defaults.object(forKey: .gradeSystemsKey) as? Data,
              let decodedData = try? decoder.decode([GradeSystem].self, from: encodedData) else {
            return
        }
        let availableSystems = fetchAvailableSystems()
        decodedData.forEach { gradeSystem in
            if !availableSystems.contains(where: { $0.id == gradeSystem.id }) {
                saveSystem(gradeSystem)
            }
        }
    }
}

extension GradeSystemService {
    func toClient() -> GradeSystemClient {
        .init {
            self.fetchAvailableSystems()
        } fetchSelectedSystem: {
            self.fetchSelectedSystem()
        } saveSystem: {
            self.saveSystem($0)
        } deleteSystem: {
            self.deleteSystem(for: $0)
        } saveSelectedSystem: {
            self.saveSelectedSystem(for: $0)
        } saveDefaultSystems: {
            self.saveDefaultSystems()
        } migrateGradeSystems: {
            self.migrateGradeSystems()
        }
    }
}
