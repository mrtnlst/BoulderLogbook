//
//  GradeSystemClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 29.01.23.
//

import Foundation
import Dependencies

struct GradeSystemClient {
    var fetchAvailableSystems: () async -> [GradeSystem]
    var fetchSelectedSystem: () async -> GradeSystem?
    var saveSystem: (GradeSystem) async -> Void
    var deleteSystem: (UUID) async -> ()
    var saveSelectedSystem: (UUID) -> Void
    var saveDefaultSystems: () async -> Void
    var migrateGradeSystems: () async -> Void
}

extension GradeSystemService {
    func toClient() -> GradeSystemClient {
        .init {
            await self.fetchAvailableSystems()
        } fetchSelectedSystem: {
            await self.fetchSelectedSystem()
        } saveSystem: {
            await self.saveSystem($0)
        } deleteSystem: {
            await self.deleteSystem(for: $0)
        } saveSelectedSystem: {
            self.saveSelectedSystem(for: $0)
        } saveDefaultSystems: {
            await self.saveDefaultSystems()
        } migrateGradeSystems: {
            await self.migrateGradeSystems()
        }
    }
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

