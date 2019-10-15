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

    /// Fetch saved custom user's decisions.
    func fetchDecisions() -> [Decision]
    /// Save decisions in storage.
    func saveDecisions(_ decisions: [Decision])
    /// Remove decision from storage.
    func removeDecision(_ decision: Decision)
    /// Returns database oberver with given request.
    func decisionObserver(for request: DataBaseRequest<Decision>) -> DataBaseObserver<Decision>

}

extension CoreDataManager: DecisionStorage {

    func fetchDecisions() -> [Decision] {
        let request = DataBaseRequest<Decision>()
        let result = fetchObjects(with: request)
        guard case let .success(decisions) = result else { return [] }

        return decisions
    }

    func saveDecisions(_ decisions: [Decision]) {
        addObjects(decisions)
    }

    func removeDecision(_ decision: Decision) {
        removeObjects([decision])
    }

    func decisionObserver(for request: DataBaseRequest<Decision>) -> DataBaseObserver<Decision> {
        return observer(for: request)
    }

}
