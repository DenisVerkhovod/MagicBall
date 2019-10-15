//
//  CoreDataObserver.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 14.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataObserver<T: StorableModel, U: NSManagedObject>: DataBaseObserver<T> {

    // MARK: - Public properties

    var observer: ((ChangesSnapshot<T>) -> Void)?

    // MARK: - Private properties

    private let context: NSManagedObjectContext
    private let fetchedResultsControllerDelegate: FetchedResultsControllerDelegate<U>
    private var modelType: ManagedObjectConvertible.Type {
        guard let type = T.self as? ManagedObjectConvertible.Type else {
            fatalError("Model type's must be conformed to ManagedObjectConvertible protocol")
        }

        return type
    }

    // MARK: - Lazy properties

    private lazy var fetchRequest: NSFetchRequest<U> = {
        let request = NSFetchRequest<U>(entityName: modelType.entityName)

        return request
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<U> = {
        let resultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                          managedObjectContext: context,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
        resultController.delegate = fetchedResultsControllerDelegate

        return resultController
    }()

    // MARK: - Initialization

    init(request: DataBaseRequest<T>, context: NSManagedObjectContext) {
        self.context = context
        self.fetchedResultsControllerDelegate = FetchedResultsControllerDelegate()

        super.init(request: request)

        configure(with: request)
    }

    // MARK: - Configuration

    private func configure(with request: DataBaseRequest<T>) {
        fetchRequest.predicate = request.predicate
        if let sortDescriptors = request.sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        } else {
            let defaultSortDescriptor = NSSortDescriptor(key: "\(Constants.uid)", ascending: true)
            fetchRequest.sortDescriptors = [defaultSortDescriptor]
        }
    }

    override func observe(_ action: @escaping (ChangesSnapshot<T>) -> Void) {
        do {
            let initialObjects = try context.fetch(fetchRequest)
            let applicationModels = initialObjects.compactMap({ modelType.toApplicationModel($0) as? T })
            action(.initial(objects: applicationModels))
            observer = action

            fetchedResultsControllerDelegate.observer = { [unowned self] (changes: ChangesSnapshot<U>) in
                guard case .modify(let info) = changes else { return }

                let insertedIndexes = info.insertedIndexes
                let deletedIndexes = info.deletedIndexes
                let modifiedIndexes = info.modifiedIndexes
                let objects = info.objects.compactMap({ self.modelType.toApplicationModel($0) as? T })
                let changesInfo = ChangesSnapshot<T>.ChangesInfo(objects: objects,
                                                                 insertedIndexes: insertedIndexes,
                                                                 deletedIndexes: deletedIndexes,
                                                                 modifiedIndexes: modifiedIndexes)
                self.observer?(.modify(changes: changesInfo))

            }

            try fetchedResultsController.performFetch()

        } catch let error {
            action(.error(error))
            observer = action
        }
    }
}

private class FetchedResultsControllerDelegate<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {

    var observer: ((ChangesSnapshot<T>) -> Void)?

    private var databaseChanges: [DataBaseChange] = []

    // MARK: - NSFetchedResultsControllerDelegate methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           databaseChanges = []
       }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                databaseChanges.append(.insert(index: newIndexPath.row))
            }
        case .delete:
            if let indexPath = indexPath {
                databaseChanges.append(.delete(index: indexPath.row))
            }
        case .move, .update:
            if let indexPath = indexPath {
                databaseChanges.append(.modify(index: indexPath.row))
            }
        @unknown default:
            print("Unknown case should be handled")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let insertedIndexes = databaseChanges.filter({ $0.isInsert }).map({ $0.index })
        let deletedIndexes = databaseChanges.filter({ $0.isDelete }).map({ $0.index })
        let modifiedIndexes = databaseChanges.filter({ $0.isModify }).map({ $0.index })
        let objects = controller.fetchedObjects as? [T] ?? []
        let changesInfo = ChangesSnapshot<T>.ChangesInfo(objects: objects,
                                                         insertedIndexes: insertedIndexes,
                                                         deletedIndexes: deletedIndexes,
                                                         modifiedIndexes: modifiedIndexes)
        observer?(.modify(changes: changesInfo))
        databaseChanges = []
    }
}

extension NSManagedObject: StorableModel {
    var identifier: String {
        return ""
    }
}
