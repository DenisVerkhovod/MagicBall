//
//  CoreDataModel+CoreDataProperties.swift
//  
//
//  Created by Denis Verkhovod on 13.10.2019.
//
//

import Foundation
import CoreData


extension CoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataModel> {
        return NSFetchRequest<CoreDataModel>(entityName: "CoreDataModel")
    }

    @NSManaged public var uid: String?

}
