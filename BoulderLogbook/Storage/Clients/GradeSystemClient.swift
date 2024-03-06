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
    var saveSystem: (GradeSystem) -> Void
    var deleteSystem: (UUID) -> ()
    var saveSelectedSystem: (UUID) -> Void
    var saveDefaultSystems: () -> Void
    var migrateGradeSystems: () -> Void
}

extension DependencyValues {
    var gradeSystemClient: GradeSystemClient {
        get { self[GradeSystemClient.self] }
        set { self[GradeSystemClient.self] = newValue }
    }
}

extension GradeSystemClient: DependencyKey {
    static let liveValue = BoulderLogbookApp.dependencies.gradeSystemService.toClient()
    static let previewValue: Self = {
        return Self(
            fetchAvailableSystems: { [.mandala, .kletterarena] },
            fetchSelectedSystem: { GradeSystem.mandala },
            saveSystem: { _ in },
            deleteSystem: { _ in },
            saveSelectedSystem: { _ in },
            saveDefaultSystems: {},
            migrateGradeSystems: {}
        )
    }()
}

