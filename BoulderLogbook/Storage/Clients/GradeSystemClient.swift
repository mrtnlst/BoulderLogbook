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

extension GradeSystemServiceType {
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
            await self.saveSelectedSystem(for: $0)
        } saveDefaultSystems: {
            await self.saveDefaultSystems()
        } migrateGradeSystems: {
            await self.migrateGradeSystems()
        }
    }
}

extension GradeSystemClient: DependencyKey {
    static var liveValue: Self = BoulderLogbookApp.dependencies.gradeSystemService.toClient()

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
