//
//  InitialConfigurationManager.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 An object which responsible for initial configuration.
 */
protocol InitialConfigurator {

    /**
     Indicates whether initial answers were setted.
     */
    var isInitialConfigured: Bool { get set }

    /**
     Preset default answers on initial launch.
     */
    func presetAnswers()

}

final class InitialConfigurationManager: InitialConfigurator {

    var isInitialConfigured: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isInitialConfigured)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.isInitialConfigured)
        }
    }

    private var answerStorage: DecisionStorage

    init(answerStorage: DecisionStorage) {
        self.answerStorage = answerStorage
    }

    func presetAnswers() {
        guard !isInitialConfigured else { return }
        let initialDecisions = Constants.presetAnswers.map({ answer in
            Decision(answer: answer, createdAt: Date(), identifier: UUID().uuidString)
        })
        answerStorage.saveDecisions(initialDecisions)
        isInitialConfigured = true
    }
}
