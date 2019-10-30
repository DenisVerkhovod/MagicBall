//
//  NSManagedContext+Save.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 13.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func saveIfNeeded() throws {
        guard hasChanges else { return }

        try save()
    }

}
