//
//  CoreDataModel+CoreDataClass.swift
//  
//
//  Created by Denis Verkhovod on 13.10.2019.
//
//

import Foundation
import CoreData

@objc(CoreDataModel)
public class CoreDataModel: NSManagedObject {

    // MARK: - Inititalization

    required public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
