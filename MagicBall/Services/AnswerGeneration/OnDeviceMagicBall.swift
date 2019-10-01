//
//  OnDeviceMagicBall.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 An object which responsible for generating random answer.
 */
protocol AnswerGenerator {

    /**
     Generate random answer.

     - Returns: Decision with random answer.
     */
    func generateAnswer() -> Decision

}

final class OnDeviceMagicBall: AnswerGenerator {

    private let answerStorage: DecisionStorage

    init(answerStorage: DecisionStorage = UserDefaults.standard) {
        self.answerStorage = answerStorage
    }

    func generateAnswer() -> Decision {
        return answerStorage.fetchDecisions().randomElement() ?? Decision(answer: L10n.Main.defaultAnswer)
    }
}
