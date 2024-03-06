//
//  CoreDataStorage.swift
//  BoulderLogbook
//
//  Created by Martin List on 26.02.24.
//

import CoreData

final class CoreDataStorage {
    let storeContainer: NSPersistentContainer

    init() {
        self.storeContainer = NSPersistentContainer(name: "DataModel")
        self.storeContainer.loadPersistentStores { _, error in
             if let error = error as NSError? {
                 assertionFailure("Unresolved error \(error), \(error.userInfo)")
             }
        }
    }
}

extension CoreDataStorage {
    var mainContext: NSManagedObjectContext {
        storeContainer.viewContext
    }

    func fetch<T: NSManagedObject>(
        predicate: NSPredicate? = nil
    ) -> [T] {
        let request = T.fetchRequest()
        request.predicate = predicate

        do {
            let result = try mainContext.fetch(request)
            return result as? [T] ?? []
        } catch {
            debugPrint(error)
            return []
        }
    }

    func insert<T: NSManagedObject>() -> T {
        return T(context: mainContext)
    }

    func delete(object: NSManagedObject) {
        mainContext.delete(object)
    }

    func save() {
        do {
            try mainContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
