//
//  Decision + ManagedObjectConvertible.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 13.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

extension Decision: ManagedObjectConvertible {

    static var managedObjectType: NSManagedObject.Type {
        return ManagedDecision.self
    }

    static var entityName: String {
        String(describing: self)
    }

    static func toApplicationModel(_ object: NSManagedObject) -> Any {
        guard
            let managedDecision = object as? ManagedDecision,
            let answer = managedDecision.answer,
            let createdAt = managedDecision.createdAt
            else {
                fatalError("Unable to create Decision from object \(object)")
        }

        return Decision(answer: answer, createdAt: createdAt)
    }

    func toManagedObject(in context: NSManagedObjectContext) -> NSManagedObject {
        return ManagedDecision()
    }

}
