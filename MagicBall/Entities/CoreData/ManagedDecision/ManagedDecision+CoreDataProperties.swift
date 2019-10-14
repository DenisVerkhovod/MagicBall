//
//  ManagedDecision+CoreDataProperties.swift
//  
//
//  Created by Denis Verkhovod on 13.10.2019.
//
//

import Foundation
import CoreData


extension ManagedDecision {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedDecision> {
        return NSFetchRequest<ManagedDecision>(entityName: "Decision")
    }

    @NSManaged public var answer: String?
    @NSManaged public var createdAt: Date?

}
