//
//  Decision + CoreData.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 13.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

// MARK: - ManagedObjectConvertible

extension Decision: ManagedObjectConvertible {

    static var managedObjectType: NSManagedObject.Type {
        return ManagedDecision.self
    }

    static var entityName: String {
        String(describing: self)
    }

    static func toApplicationModel(_ object: NSManagedObject) -> StorableModel {
        guard
            let managedDecision = object as? ManagedDecision,
            let answer = managedDecision.answer,
            let createdAt = managedDecision.createdAt,
            let uuid = managedDecision.uuid
            else {
                fatalError("Unable to create Decision from object \(object)")
        }

        return Decision(answer: answer, createdAt: createdAt, identifier: uuid)
    }

    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        return ManagedDecision(uuid: identifier, answer: answer, createdAt: createdAt, in: context)
    }

}

// MARK: - ApplicationLayerModel

extension Decision: StorableModel {}
