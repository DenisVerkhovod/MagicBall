//
//  CoreDataStack.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 11.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {

    // MARK: - Private properties

    private let modelName: String

    // MARK: - Initialization

    init(modelName: String) {
        self.modelName = modelName
    }

    // MARK: - Lazy properties

    lazy var mainContext: NSManagedObjectContext = {
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        return viewContext
    }()

    lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        newbackgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

        return newbackgroundContext
    }()

    private lazy var storeURL: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationDocumentDirectory = urls[urls.count - 1]

        return applicationDocumentDirectory.appendingPathComponent("\(modelName).sqlite")
    }()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)

        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                print("Unable to load persistent store. Error: \(error.localizedDescription)")
            }
        }

        return container
    }()
}
