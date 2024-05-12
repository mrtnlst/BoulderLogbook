//
//  CoreDataStorageMock.swift
//  BoulderLogbookTests
//
//  Created by Martin List on 12.05.24.
//

import CoreData
@testable import BoulderLogbook

final class CoreDataStorageMock: CoreDataStorageType {
    static let shared = CoreDataStorageMock()
    let storeContainer: NSPersistentContainer

    private init() {
        self.storeContainer = NSPersistentContainer(name: "DataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        self.storeContainer.persistentStoreDescriptions = [description]
        self.storeContainer.loadPersistentStores { _, error in
             if let error = error as NSError? {
                 assertionFailure("Unresolved error \(error), \(error.userInfo)")
             }
        }
    }
}

extension CoreDataStorageMock {
    func deleteAll(of type: NSManagedObject.Type, context: NSManagedObjectContext) throws {
        let request = type.fetchRequest()

        let results = try context.fetch(request)
        results.forEach { result in
            context.delete(result as! NSManagedObject)
        }
    }
}
