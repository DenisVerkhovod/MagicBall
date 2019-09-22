//
//  InitialConfigurationManager.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 An object which preset default answers on initial launch.
 */
final class InitialConfigurationManager {
    
    static func presetAnswers() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: Constants.isInitialConfigured) else { return }
        defaults.set(Constants.presetAnswers, forKey: Constants.answers)
        defaults.set(true, forKey: Constants.isInitialConfigured)
    }
}
