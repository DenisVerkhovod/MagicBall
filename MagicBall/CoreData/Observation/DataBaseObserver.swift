//
//  DataBaseObserver.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 14.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 Represents database changes.
 */
enum DataBaseChange {
    case insert(index: Int)
    case delete(index: Int)
    case modify(index: Int)

    var index: Int {
        switch self {
        case let .insert(index: index):
            return index
        case let .delete(index: index):
            return index
        case let .modify(index: index):
            return index
        }
    }

    var isInsert: Bool {
        guard case .insert = self else { return false }

        return true
    }

    var isDelete: Bool {
        guard case .delete = self else { return false }

        return true
    }

    var isModify: Bool {
        guard case .modify = self else { return false }

        return true
    }
}

/**
 Stores snapshot of current changes in database.
 */
enum ChangesSnapshot<T: StorableModel> {

    struct ChangesInfo<T> {

        let objects: [T]
        let insertedIndexes: [Int]
        let deletedIndexes: [Int]
        let modifiedIndexes: [Int]

    }

    case initial(objects: [T])
    case modify(changes: ChangesInfo<T>)
    case error(Error?)
}

class DataBaseObserver<T: StorableModel> {

    let request: DataBaseRequest<T>

    // MARK: - Initialization

    init(request: DataBaseRequest<T>) {
        self.request = request
    }

    func observe(_ closure: @escaping (ChangesSnapshot<T>) -> Void) {
        assertionFailure("Must be overriden")
    }
}
