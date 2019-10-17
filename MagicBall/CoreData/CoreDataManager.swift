//
//  CoreDataManager.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 13.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {

    // MARK: - Private properties

    private let coreDataStack: CoreDataStack

    private var mainContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    private var backgroundContext: NSManagedObjectContext {
        return coreDataStack.backgroundContext
    }

    // MARK: - Initialization

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Perform tasks

    private func performInBackground(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let backgroundContext = coreDataStack.backgroundContext
        backgroundContext.perform {
            action(backgroundContext)
        }
    }

    private func performAndWaitInBackground(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let backgroundContext = coreDataStack.backgroundContext
        backgroundContext.performAndWait {
            action(backgroundContext)
        }
    }
}

// MARK: - DataBaseManager

extension CoreDataManager: DataBaseManager {

    func observer<T>(for request: DataBaseRequest<T>) -> DataBaseObserver<T> {

        return CoreDataObserver(request: request, context: mainContext)
    }

    func fetchObjects<T>(
        with request: DataBaseRequest<T>
    ) -> Result<[T], DataBaseError> where T: ManagedObjectConvertible {
        var resultToReturn: Result<[T], DataBaseError>!
        let modelType = T.self

        performAndWaitInBackground { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: T.entityName)
            fetchRequest.predicate = request.predicate
            fetchRequest.sortDescriptors = request.sortDescriptors

            do {
                guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else {
                    resultToReturn = .failure(.fetchError(nil))
                    return
                }
                let convertedResult = results.compactMap({ modelType.toApplicationModel($0) as? T })
                resultToReturn = .success(convertedResult)

            } catch let error {
               resultToReturn = .failure(.fetchError(error))
            }
        }

        return resultToReturn
    }

    @discardableResult
    func addObjects<T>(
        _ objects: [T]
    ) -> Result<[T], DataBaseError> where T: ManagedObjectConvertible {
        var resultToReturn: Result<[T], DataBaseError>!

        performAndWaitInBackground { context in
            var savedObjects: [T] = []
            objects.forEach { object in
                object.toManagedObject(in: context)
                savedObjects.append(object)
            }

            do {
                try context.saveIfNeeded()
                resultToReturn = .success(savedObjects)
            } catch let error {
                resultToReturn = .failure(.saveError(error))
            }
        }

        return resultToReturn
    }

    @discardableResult
    func removeObjects<T>(
        _ objects: [T]
    ) -> Result<[T], DataBaseError> where T: ManagedObjectConvertible {
        var resultToReturn: Result<[T], DataBaseError>!
        let modelType = T.self

        performAndWaitInBackground { context in
            let uuids = objects.map { $0.identifier }

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: T.entityName)
            fetchRequest.predicate = NSPredicate(format: "\(#keyPath(CoreDataModel.uuid)) IN %@", uuids)

            do {
                guard let results = try context.fetch(fetchRequest) as? [NSManagedObject] else {
                    resultToReturn = .failure(.deletionError(nil))
                    return
                }
                var deletedItems: [T?] = []
                results.forEach { object in
                    context.delete(object)
                    let convertedModel = modelType.toApplicationModel(object) as? T
                    deletedItems.append(convertedModel)
                }
                try context.saveIfNeeded()
                resultToReturn = .success(deletedItems.compactMap({ $0 }))

            } catch let error {
                resultToReturn = .failure(.deletionError(error))
            }
        }

        return resultToReturn
      }
}
