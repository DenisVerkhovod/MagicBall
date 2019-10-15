//
//  AnswerListModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/30/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData

final class AnswerListModel {

    // MARK: Public properties

    var dataBaseChangesHandler: ((ChangesSnapshot<Decision>) -> Void)?
    var numberOfDecisions: Int {
        return decisions.count
    }

    // MARK: - Private properties

    private let decisionStorage: DecisionStorage
    private var decisions: [Decision] = []
    private var decisionChangesObserver: DataBaseObserver<Decision>?

    // MARK: - Inititalization

    init(decisionStorage: DecisionStorage) {
        self.decisionStorage = decisionStorage

        configureObservation()
    }

    // MARK: - Decision handlers

    func decision(at index: Int) -> Decision {
        return decisions[index]
    }

    func saveDecisions(_ decisions: [Decision]) {
        decisionStorage.saveDecisions(decisions)
    }

    func removeDecision(_ decision: Decision) {
        decisionStorage.removeDecision(decision)
    }

    // MARK: - Configure observation

    private func configureObservation() {
        let createdDateSortDescriptor = NSSortDescriptor(key: Constants.createdAt, ascending: false)
        let request = DataBaseRequest<Decision>(predicate: nil, sortDescriptors: [createdDateSortDescriptor])
        let observer = decisionStorage.decisionObserver(for: request)
        decisionChangesObserver = observer
        observer.observe { [weak self] changes in
            switch changes {
            case let .initial(objects: decisions):
                self?.decisions = decisions

            case let .modify(changes: info):
                self?.decisions = info.objects

            default:
                break
            }
            self?.dataBaseChangesHandler?(changes)
        }
    }
}
