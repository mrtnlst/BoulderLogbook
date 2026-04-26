//
//  GradeSystemServiceType.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.04.26.
//

import Foundation

protocol GradeSystemServiceType: Sendable {
    func fetchAvailableSystems() async -> [GradeSystem]
    func fetchSelectedSystem() async -> GradeSystem?
    func saveSystem(_ system: GradeSystem) async
    func saveSelectedSystem(for id: UUID) async
    func deleteSystem(for id: UUID) async
    func saveDefaultSystems() async
    func migrateGradeSystems() async
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
