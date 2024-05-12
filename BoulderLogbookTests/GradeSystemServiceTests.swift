//
//  GradeSystemServiceTests.swift
//  BoulderLogbookTests
//
//  Created by Martin List on 12.05.24.
//

import XCTest
import CoreData
@testable import BoulderLogbook

final class GradeSystemServiceTests: XCTestCase {
    private var sut: GradeSystemService!
    private var userDefaults: UserDefaults!
    private var storage: CoreDataStorageMock = .shared
    private var testContext: NSManagedObjectContext!

    override func setUp() async throws {
        try await super.setUp()
        userDefaults = UserDefaults(suiteName: String(describing: Self.self))
        testContext = storage.storeContainer.newBackgroundContext()
        sut = .init(
            storage: storage,
            backgroundContext: testContext,
            defaults: userDefaults
        )
        try storage.deleteAll(of: LogbookSectionMO.self, context: testContext)
    }

    func test_migrateGradeSystems() async throws {
        // Given
        let expectedSystem = GradeSystem.mandala
        try setupInUserDefaults([expectedSystem], for: "grade-systems")

        // When
        await sut.migrateGradeSystems()

        // Then
        let results = await sut.fetchAvailableSystems()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, expectedSystem.id)
        XCTAssertEqual(results.first?.name, expectedSystem.name)
        XCTAssertEqual(results.first?.grades.count, expectedSystem.grades.count)
        validate(gradeSystem1: results.first, inComparisonTo: expectedSystem)
    }

    func test_saveSystem() async throws {
        // Given
        let expectedSystem = GradeSystem.mandala

        // When
        await sut.saveSystem(expectedSystem)

        // Then
        let results = await sut.fetchAvailableSystems()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, expectedSystem.id)
        XCTAssertEqual(results.first?.name, expectedSystem.name)
        XCTAssertEqual(results.first?.grades.count, expectedSystem.grades.count)
        validate(gradeSystem1: results.first, inComparisonTo: expectedSystem)
    }

    func test_deleteSystem() async throws {
        // Given
        let expectedSystem = GradeSystem.mandala
        await sut.saveSystem(expectedSystem)
        let availableSystems = await sut.fetchAvailableSystems()
        XCTAssertFalse(availableSystems.isEmpty)

        // When
        await sut.deleteSystem(for: expectedSystem.id)

        // Then
        let emptyResult = await sut.fetchAvailableSystems()
        XCTAssertTrue(emptyResult.isEmpty)
    }

    func test_saveSelectedSystem() async {
        // Given
        let expectedSystem = GradeSystem.mandala
        await sut.saveSystem(expectedSystem)

        // When
        sut.saveSelectedSystem(for: expectedSystem.id)

        // The
        let result = await sut.fetchSelectedSystem()
        validate(gradeSystem1: result, inComparisonTo: expectedSystem)
    }
}

private extension GradeSystemServiceTests {
    private func setupInUserDefaults(_ object: Encodable, for key: String) throws {
        let data = try JSONEncoder().encode(object)
        userDefaults.set(data, forKey: key)
    }

    private func validate(gradeSystem1: GradeSystem?, inComparisonTo gradeSystem2: GradeSystem) {
        gradeSystem2.grades.forEach { grade in
            let migratedGrade = gradeSystem1?.grades.first(where: { $0.id == grade.id })
            XCTAssertEqual(migratedGrade?.name, grade.name)
            XCTAssertEqual(migratedGrade?.difficulty, grade.difficulty)
            for (index, color) in (grade.color.cgColor?.components ?? []).enumerated() {
                let migratedColor = migratedGrade?.color.cgColor?.components?[index] ?? 0
                let acceptableDelta = 0.0000001
                let delta = abs(color - migratedColor)
                XCTAssertTrue(delta < acceptableDelta)
            }
        }
    }
}
