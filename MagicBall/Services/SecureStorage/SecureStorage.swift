//
//  SecureStorage.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 10/4/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import KeychainSwift

/**
 A wrapper for keychain storage
 */
protocol SecureStorage {

    /**
     Stores the text value in the keychain item under the given key.
     
     - Parameter value: Text string to be written to the keychain.
     - Parameter defaultName: Key under which the text value is stored in the keychain.
     - Returns: True if the text was successfully written to the keychain.
     */
    @discardableResult func set(_ value: String, forKey defaultName: String) -> Bool

    /**
     Retrieves the text value from the keychain that corresponds to the given key.
     
     - Parameter defaultName: The key that is used to read the keychain item.
     - Returns: The text value from the keychain. Returns nil if unable to read the item.
     */
    func value(forKey defaultName: String) -> String?

    /**
     Deletes the item under specified key from keychain.
     
     - Parameter key: The key that is used to delete the keychain item.
     - Returns: True if the item was successfully deleted from keychain.
     */
    func delete(_ key: String) -> Bool

}

extension KeychainSwift: SecureStorage {

    @discardableResult func set(_ value: String, forKey defaultName: String) -> Bool {

        return set(value, forKey: defaultName, withAccess: nil)
    }

    func value(forKey defaultName: String) -> String? {

        return get(defaultName)
    }

}
