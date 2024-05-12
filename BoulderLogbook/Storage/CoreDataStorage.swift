//
//  CoreDataStorage.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.02.24.
//

import CoreData

protocol CoreDataStorageType {
    var storeContainer: NSPersistentContainer { get }
    var mainContext: NSManagedObjectContext { get }
    func fetch<T: NSManagedObject>(predicate: NSPredicate?, on context: NSManagedObjectContext) -> [T]
    func insert<T: NSManagedObject>(into context: NSManagedObjectContext) -> T
    func delete(object: NSManagedObject, from context: NSManagedObjectContext)
    func save(on context: NSManagedObjectContext)
}

final class CoreDataStorage: CoreDataStorageType {
    static let shared = CoreDataStorage()
    let storeContainer: NSPersistentContainer

    private init() {
        self.storeContainer = NSPersistentContainer(name: "DataModel")
        self.storeContainer.loadPersistentStores { _, error in
             if let error = error as NSError? {
                 assertionFailure("Unresolved error \(error), \(error.userInfo)")
             }
        }
    }
}

extension CoreDataStorageType {
    var mainContext: NSManagedObjectContext {
        storeContainer.viewContext
    }

    func fetch<T: NSManagedObject>(
        predicate: NSPredicate? = nil,
        on context: NSManagedObjectContext
    ) -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate

        do {
            let result = try context.fetch(request)
            return result as? [T] ?? []
        } catch {
            debugPrint(error)
            return []
        }
    }

    func insert<T: NSManagedObject>(
        into context: NSManagedObjectContext
    ) -> T {
        return T(context: context)
    }

    func delete(object: NSManagedObject, from context: NSManagedObjectContext) {
        context.delete(object)
    }

    func save(
        on context: NSManagedObjectContext
    ) {
        do {
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
