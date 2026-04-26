//
//  GradeSystemClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct GradeSystemClient {
    var fetchAvailableSystems: @Sendable () async -> [GradeSystem] = { [] }
    var fetchSelectedSystem: @Sendable () async -> GradeSystem? = { nil }
    var saveSystem: @Sendable (GradeSystem) async -> Void = { _ in }
    var deleteSystem: @Sendable (UUID) async -> () = { _ in }
    var saveSelectedSystem: @Sendable (UUID) async -> Void = { _ in }
    var saveDefaultSystems: @Sendable () async -> Void = {}
    var migrateGradeSystems: @Sendable () async -> Void = {}
}

extension GradeSystemClient: DependencyKey {
    static let liveValue = Self()

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

extension DependencyValues {
    var gradeSystemClient: GradeSystemClient {
        get { self[GradeSystemClient.self] }
        set { self[GradeSystemClient.self] = newValue }
    }
}
