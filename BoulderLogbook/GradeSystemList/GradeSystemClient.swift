//
//  GradeSystemClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import Dependencies

struct GradeSystemClient {
    var fetchAvailableSystems: () -> [GradeSystem]
    var fetchSelectedSystem: () -> UUID?
    var saveSystem: (GradeSystem) -> ()
    var deleteSystems: ([GradeSystem]) -> ()
    var saveSelectedSystem: (UUID) -> ()
}

extension DependencyValues {
    var gradeSystemClient: GradeSystemClient {
        get { self[GradeSystemClient.self] }
        set { self[GradeSystemClient.self] = newValue }
    }
}

extension GradeSystemClient: DependencyKey {
    static let liveValue: Self = {
        let defaults = UserDefaults.standard
        let gradeSystemsKey = "grade-systems"
        let selectedGradeSystemKey = "selected-grade-system"
        return Self(
            fetchAvailableSystems: {
                guard let encodedData = defaults.object(forKey: gradeSystemsKey) as? Data,
                      let decodedData = try? JSONDecoder().decode([GradeSystem].self, from: encodedData)
                else {
                    return []
                }
                return decodedData
            },
            fetchSelectedSystem: {
                guard let encodedData = defaults.object(forKey: selectedGradeSystemKey) as? Data,
                      let decodedData = try? JSONDecoder().decode(UUID.self, from: encodedData)
                else {
                    return nil
                }
                return decodedData
            }, saveSystem: { newValue in
                var gradeSystems: [GradeSystem]
                if let encodedData = defaults.object(forKey: gradeSystemsKey) as? Data,
                   let decodedData = try? JSONDecoder().decode([GradeSystem].self, from: encodedData) {
                    gradeSystems = decodedData
                } else {
                    gradeSystems = []
                }
                gradeSystems.append(newValue)
                let data = try? JSONEncoder().encode(gradeSystems)
                defaults.set(data, forKey: gradeSystemsKey)
            },
            deleteSystems: { oldValues in
                guard let encodedData = defaults.object(forKey: gradeSystemsKey) as? Data,
                      var decodedData = try? JSONDecoder().decode([GradeSystem].self, from: encodedData)
                else {
                    return
                }
                oldValues.forEach { oldValue in
                    decodedData.removeAll(where: { $0.id == oldValue.id })
                }
                let data = try? JSONEncoder().encode(decodedData)
                defaults.set(data, forKey: gradeSystemsKey)
            }, saveSelectedSystem: { newValue in
                let data = try? JSONEncoder().encode(newValue)
                defaults.set(data, forKey: selectedGradeSystemKey)
            }
        )
    }()
    
    static let previewValue: Self = {
        return Self(
            fetchAvailableSystems: { [mandalaGrades, kletterarenaGrades] },
            fetchSelectedSystem: { mandalaGrades.id },
            saveSystem: { _ in },
            deleteSystems: { _ in },
            saveSelectedSystem: { _ in }
        )
    }()
}

