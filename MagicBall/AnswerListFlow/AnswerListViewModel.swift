//
//  AnswerListViewModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/30/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

final class AnswerListViewModel {

    // MARK: - Public properties

    var numberOfDecisions: Int {
        return model.numberOfDecisions
    }

    // MARK: - Private properties

    private let model: AnswerListModel

    // MARK: - Inititalization

    init(model: AnswerListModel) {
        self.model = model
    }

    // MARK: - Decision handlers

    func fetchDecisions() {
        model.fetchDecisions()
    }

    func decision(at index: Int) -> PresentableDecision {
        let decision = model.decision(at: index)
        var presentableDecision = decision.toPresentableDecision()
        presentableDecision.removingHandler = { [weak self] in
            self?.model.removeDecision(decision)
        }

        return presentableDecision
    }

    func saveDecision(with text: String) {
        let newDecision = Decision(answer: text)
        model.saveDecisions([newDecision])
    }
}
