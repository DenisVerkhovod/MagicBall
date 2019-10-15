//
//  ManagedDecision+CoreDataClass.swift
//  
//
//  Created by Denis Verkhovod on 13.10.2019.
//
//

import Foundation
import CoreData

@objc(ManagedDecision)
public class ManagedDecision: CoreDataModel {

    // MARK: - Inititalization

    convenience init(uid: String, answer: String, createdAt: Date, in context: NSManagedObjectContext) {
        let entityName = String(describing: Decision.self)
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Failed to create entity description for \(entityName)")
        }
        self.init(entity: entity, insertInto: context)

        self.uid = uid
        self.answer = answer
        self.createdAt = createdAt
    }

    public required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
