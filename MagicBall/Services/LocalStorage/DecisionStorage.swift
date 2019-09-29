//
//  DecisionStorage.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 An object which will provide storage for user's answer.
 */
protocol DecisionStorage {

    /// Indicates whether initial answers were setted.
    var isInititalConfigured: Bool { get set }
    
    /// Fetch saved custom user's decisions.
    func fetchDecisions() -> [Decision]
    /// Save decisions in storage.
    func saveDecisions(_ decisions: [Decision])
    /// Remove decision from storage.
    func removeDecision(_ decision: Decision)

}

extension UserDefaults: DecisionStorage {

    var isInititalConfigured: Bool {
        get {
            bool(forKey: Constants.isInitialConfigured)
        }
        set {
            set(newValue, forKey: Constants.isInitialConfigured)
        }
    }

    func fetchDecisions() -> [Decision] {
        stringArray(forKey: Constants.answers)?.map({ Decision(answer: $0) }) ?? []
    }
    
    func saveDecisions(_ decisions: [Decision]) {
        var storedDecisions = fetchDecisions()
        storedDecisions.append(contentsOf: decisions)
        let answers = storedDecisions.map({ $0.answer })
        set(answers, forKey: Constants.answers)
    }

    func removeDecision(_ decision: Decision) {
        let updatedDecisions = fetchDecisions().filter({ $0.answer != decision.answer })
        saveDecisions(updatedDecisions)
    }
}
