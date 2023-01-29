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
    var fetchSelectedSystem: () -> GradeSystem?
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
        return Self (
            fetchAvailableSystems: {
                guard let encodedData = defaults.object(forKey: gradeSystemsKey) as? Data,
                      let decodedData = try? JSONDecoder().decode([GradeSystem].self, from: encodedData)
                else {
                    return []
                }
                return decodedData
            },
            fetchSelectedSystem: {
                guard let encodedData = defaults.object(forKey: gradeSystemsKey) as? Data,
                      let decodedData = try? JSONDecoder().decode(GradeSystem.self, from: encodedData)
                else {
                    return nil
                }
                return decodedData
            }
        )
    }()
}
