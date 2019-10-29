//
//  AnswerListModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/30/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

final class AnswerListModel: NavigationNode {

    // MARK: Public properties

    var decisions: BehaviorRelay<[Decision]>

    // MARK: - Private properties

    private let decisionStorage: DecisionStorage
    private var decisionChangesObserver: DataBaseObserver<Decision>?

    // MARK: - Inititalization

    init(parent: NavigationNode, decisionStorage: DecisionStorage) {
        self.decisionStorage = decisionStorage
        self.decisions = BehaviorRelay(value: [])

        super.init(parent: parent)

        configureObservation()
    }

    // MARK: - Decision handlers

    func save(_ decisions: [Decision]) {
        decisionStorage.saveDecisions(decisions)
    }

    func removeDecision(with identifier: String) {
        guard let decisionToRemove = decisions.value.first(where: { $0.identifier == identifier }) else { return }

        decisionStorage.removeDecision(decisionToRemove)
    }

    // MARK: - Configure observation

    private func configureObservation() {
        let createdDateSortDescriptor = NSSortDescriptor(
            key: "\(#keyPath(ManagedDecision.createdAt))",
            ascending: false
        )
        let request = DataBaseRequest<Decision>(predicate: nil, sortDescriptors: [createdDateSortDescriptor])
        let observer = decisionStorage.decisionObserver(for: request)
        decisionChangesObserver = observer
        observer.observe { [weak self] changes in
            switch changes {
            case let .initial(objects: decisions):
                self?.decisions.accept(decisions)

            case let .modify(changes: info):
                self?.decisions.accept(info.objects)

            default:
                break
            }
        }
    }
}
