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
    case none

    struct Info {
        let insertedIndexes: [Int]
        let deletedIndexes: [Int]
        let updatedIndexes: [Int]
    }
}

extension ChangesSnapshot {

    func toTableViewChanges() -> TableViewChanges {
        switch self {
        case .initial:
            return .initial

        case let .modify(changes: info):
            let tableViewChanges = TableViewChanges.update(info: TableViewChanges.Info(
                insertedIndexes: info.insertedIndexes,
                deletedIndexes: info.deletedIndexes,
                updatedIndexes: info.modifiedIndexes)
            )
            return tableViewChanges

        case let .error(error):
            print("Updation error: \(String(describing: error))")
            return .none
        }
    }

}
