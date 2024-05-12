//
//  LogbookEntryServiceTests.swift
//  BoulderLogbookTests
//
//  Created by Martin List on 12.05.24.
//

import XCTest
import CoreData
@testable import BoulderLogbook

final class LogbookEntryServiceTests: XCTestCase {
    private var sut: LogbookEntryService!
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

    func test_migrateLogbookEntries() async throws {
        // Given
        let date = Date.now
        let notes = "notes"
        let top = Top()
        try setupInUserDefaults(
            [
                Logbook.Section.Entry(
                    date: date,
                    notes: notes,
                    tops: [top],
                    gradeSystem: GradeSystem.mandala.id
                )
            ],
            for: "logbook-entries"
        )

        // When
        await sut.migrateLogbookEntries()

        // Then
        let results = await sut.fetchAvailableSections()
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.date, date.yearMonthDate)
        XCTAssertEqual(results.first?.entries.count, 1)
        XCTAssertEqual(results.first?.entries.first?.date, date)
        XCTAssertEqual(results.first?.entries.first?.notes, notes)
        XCTAssertEqual(results.first?.entries.first?.tops.count, 1)
        XCTAssertEqual(results.first?.entries.first?.tops.first, top)
    }

    func test_saveEntry() async throws {
        // Given
        let entry: Logbook.Section.Entry = .init(
            id: UUID(),
            date: Date.now,
            notes: "notes",
            tops: [
                .init(
                    id: UUID(),
                    grade: UUID(),
                    isAttempt: true,
                    wasFlash: true,
                    wasOnsight: true
                )
            ],
            gradeSystem: UUID()
        )

        // When
        await sut.saveEntry(entry)

        // Then
        let fetchAvailableEntriesResult = await sut.fetchAvailableEntries()
        XCTAssertEqual(fetchAvailableEntriesResult.count, 1)
        XCTAssertEqual(fetchAvailableEntriesResult.first, entry)

        let fetchAvailableSectionsResult = await sut.fetchAvailableSections()
        XCTAssertEqual(fetchAvailableSectionsResult.count, 1)
        XCTAssertEqual(fetchAvailableSectionsResult.first?.date, entry.date.yearMonthDate)
        XCTAssertEqual(fetchAvailableSectionsResult.first?.entries.count, 1)
        XCTAssertEqual(fetchAvailableSectionsResult.first?.entries.first, entry)
    }

    func test_updateEntry() async throws {
        // Given
        var entry: Logbook.Section.Entry = .init(
            id: UUID(),
            date: Date.now,
            notes: "notes",
            tops: [
                .init(
                    id: UUID(),
                    grade: UUID(),
                    isAttempt: true,
                    wasFlash: true,
                    wasOnsight: true
                )
            ],
            gradeSystem: UUID()
        )
        await sut.saveEntry(entry)
        entry.notes = "update"
        entry.date = Date.now
        entry.tops = [.sample1]

        // When
        await sut.updateEntry(entry)

        // Then
        let result = await sut.fetchAvailableEntries()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first, entry)
    }

    func test_deleteEntry() async throws {
        // Given
        let entry: Logbook.Section.Entry = .init(
            id: UUID(),
            date: Date.now,
            gradeSystem: UUID()
        )
        await sut.saveEntry(entry)

        // When
        await sut.deleteEntry(for: entry.id)

        // Then
        let result = await sut.fetchAvailableEntries()
        XCTAssertEqual(result.count, 0)
    }

    func test_deleteEntries() async throws {
        // Given
        let entry: Logbook.Section.Entry = .init(
            id: UUID(),
            date: Date.now,
            gradeSystem: GradeSystem.mandala.id
        )
        await sut.saveEntry(entry)

        // When
        await sut.deleteEntries(of: GradeSystem.mandala.id)

        // Then
        let result = await sut.fetchAvailableEntries()
        XCTAssertEqual(result.count, 0)
    }
}

private extension LogbookEntryServiceTests {
    private func setupInUserDefaults(_ object: Encodable, for key: String) throws {
        let data = try JSONEncoder().encode(object)
        userDefaults.set(data, forKey: key)
    }
}
