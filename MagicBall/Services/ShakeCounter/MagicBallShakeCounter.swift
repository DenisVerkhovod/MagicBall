//
//  MagicBallShakeCounter.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 10/6/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import KeychainSwift

/**
 An object which responsible for storing the number of shakes.
 */
protocol ShakeCounter {

    /**
     Total number of shakes.
     */
    var numberOfShakes: Int { get }

    /**
     Increases total number of shakes.
     */
    func increaseCounter()

}

final class MagicBallShakeCounter: ShakeCounter {

    var numberOfShakes: Int {
        let totalShakes = secureStorage.value(forKey: Constants.totalShakes) ?? ""

        return Int(totalShakes) ?? 0
    }

    private let secureStorage: SecureStorage

    init(secureStorage: SecureStorage = KeychainSwift()) {
        self.secureStorage = secureStorage
    }

    func increaseCounter() {
        let updatedNumberOfShakes = numberOfShakes + 1
        secureStorage.set("\(updatedNumberOfShakes)", forKey: Constants.totalShakes)
    }
}
