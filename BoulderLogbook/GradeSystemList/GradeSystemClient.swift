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
    var saveSystem: (GradeSystem) -> Void
    var deleteSystem: (GradeSystem) -> ()
    var saveSelectedSystem: (UUID) -> Void
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
                
                if let existingValue = gradeSystems.firstIndex(where: { $0.id == newValue.id }) {
                    gradeSystems[existingValue] = newValue
                } else {
                    gradeSystems.append(newValue)
                }
                let data = try? JSONEncoder().encode(gradeSystems)
                defaults.set(data, forKey: gradeSystemsKey)
            },
            deleteSystem: { oldValue in
                guard let encodedData = defaults.object(forKey: gradeSystemsKey) as? Data,
                      var decodedData = try? JSONDecoder().decode([GradeSystem].self, from: encodedData)
                else {
                    return
                }
                decodedData.removeAll(where: { $0.id == oldValue.id })
                
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
            deleteSystem: { _ in },
            saveSelectedSystem: { _ in }
        )
    }()
}

