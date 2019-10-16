//
//  DataBaseManager.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 13.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

/**
 An object which describes the request to database.
 */
struct DataBaseRequest<T: StorableModel> {

    // MARK: - Public properties

    let predicate: NSPredicate?
    let sortDescriptors: [NSSortDescriptor]?

    // MARK: Initialization

    public init(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
    }
}

/**
 Represents database errors.
 */
enum DataBaseError: Error {
    case fetchError(Error?)
    case saveError(Error?)
    case deletionError(Error?)
}

/**
 An object through which the interaction with the database.
 */
protocol DataBaseManager {

    /**
     Creates DataBaseObserver with given request.

     - Parameter request: DataBaseRequest to be observed.
     - Returns: Observer with given request.
     */
    func observer<T>(for request: DataBaseRequest<T>) -> DataBaseObserver<T>

    /**
     Retrieves objects from database with given request.

     - Parameter request: A request to database.
     - Returns: Swift.Result with array of fetched objects in case of success
     or with an error in case of failure.
     */
    func fetchObjects<T: ManagedObjectConvertible>(with request: DataBaseRequest<T>) -> Result<[T], DataBaseError>

    /**
     Saves given objects in database.

     - Parameter objects: An array of objects to save.
     - Returns: Swift.Result with array of saves objects in case of success
     or with an error in case of failure.
     */
    @discardableResult
    func addObjects<T: ManagedObjectConvertible>(_ objects: [T]) -> Result<[T], DataBaseError>

    /**
     Removes given objects from database.

     - Parameter objects: An array of objects to remove.
     - Returns: Swift.Result with array of removed objects in case of success
     or with an error in case of failure.
     */
    @discardableResult
    func removeObjects<T: ManagedObjectConvertible>(_ objects: [T]) -> Result<[T], DataBaseError>

}

/**
 Abstraction which represents application layer's model.
 */
protocol StorableModel { }

/**
 To be able to be stored in CoreData, the model have to conform to ManagedObjectConvertible.
 */
protocol ManagedObjectConvertible: StorableModel {

    /// Returns type of object.
    static var managedObjectType: NSManagedObject.Type { get }
    /// Retruns entity name.
    static var entityName: String { get }

    /// A unique identifier common to an object's representing on all layers.
    var identifier: String { get }

    /**
     Convert object to application layer instance.
     
     - Parameter object: An object to convert.
     - Returns: Application layer instance.
     */
    static func toApplicationModel(_ object: NSManagedObject) -> StorableModel

    /**
     Returns NSManagedObject in given context.

     - Parameter context: Given context.
     */
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject

}
