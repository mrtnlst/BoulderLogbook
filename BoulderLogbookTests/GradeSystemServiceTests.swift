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
        try setupInUserDefaults([GradeSystem.mandala], for: "grade-systems")

        // When
        await sut.migrateGradeSystems()

        // Then
        let results = await sut.fetchAvailableSystems()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, GradeSystem.mandala.id)
        XCTAssertEqual(results.first?.name, GradeSystem.mandala.name)
        XCTAssertEqual(results.first?.grades.count, GradeSystem.mandala.grades.count)
        GradeSystem.mandala.grades.forEach { grade in
            let migratedGrade = results.first?.grades.first(where: { $0.id == grade.id })
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

private extension GradeSystemServiceTests {
    private func setupInUserDefaults(_ object: Encodable, for key: String) throws {
        let data = try JSONEncoder().encode(object)
        userDefaults.set(data, forKey: key)
    }
}
