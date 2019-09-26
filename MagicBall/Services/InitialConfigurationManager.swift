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
     Preset default answers on initial launch.
     */
    func presetAnswers()

}

final class InitialConfigurationManager: InitialConfigurator {

    private var answerStorage: AnswerStorage

    init(answerStorage: AnswerStorage = UserDefaults.standard) {
        self.answerStorage = answerStorage
    }

    func presetAnswers() {
        guard !answerStorage.isInititalConfigured else { return }
        answerStorage.addAnswers(Constants.presetAnswers)
        answerStorage.isInititalConfigured = true
    }
}
