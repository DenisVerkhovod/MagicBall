//
//  AnswerListModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/30/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

final class AnswerListModel {

    // MARK: Public properties

    var numberOfDecisions: Int {
        return decisions.count
    }

    // MARK: - Private properties

    private let decisionStorage: DecisionStorage
    private var decisions: [Decision] = []

    // MARK: - Inititalization

    init(decisionStorage: DecisionStorage) {
        self.decisionStorage = decisionStorage
    }

    // MARK: - Decision handlers

    func fetchDecisions() {
        decisions = decisionStorage.fetchDecisions()
    }

    func decision(at index: Int) -> Decision {
        return decisions[index]
    }

    func saveDecisions(_ decisions: [Decision]) {
        decisionStorage.saveDecisions(decisions)
        fetchDecisions()
    }

    func removeDecision(_ decision: Decision) {
        decisionStorage.removeDecision(decision)
        fetchDecisions()
    }
}
