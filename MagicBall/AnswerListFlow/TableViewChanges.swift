//
//  TableViewChanges.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 16.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

enum TableViewChanges {
    case initial
    case update(info: Info)

    struct Info {
        let insertedIndexes: [Int]
        let deletedIndexes: [Int]
        let updatedIndexes: [Int]
    }
}
