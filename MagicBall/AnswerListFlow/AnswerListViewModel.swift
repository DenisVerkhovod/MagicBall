//
//  AnswerListViewModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/30/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

enum TableViewChanges {
    case initial
    case update(info: Info)

    struct Info {
        let insertedIndexes: [Int]
        let deletedIndexes: [Int]
        let updatedIndexes: [Int]
    }
}

final class AnswerListViewModel {

    // MARK: - Public properties

    var tableViewChangesHandler: ((TableViewChanges) -> Void)?
    var numberOfDecisions: Int {
        return model.numberOfDecisions
    }

    // MARK: - Private properties

    private let model: AnswerListModel

    // MARK: - Inititalization

    init(model: AnswerListModel) {
        self.model = model

        configureObservers()
    }

    // MARK: - Decision handlers

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

    // MARK: - Configure observers

    private func configureObservers() {
        model.dataBaseChangesHandler = { [weak self] dataBaseChanges in
            self?.handleChanges(dataBaseChanges)
        }
    }

    // MARK: - Helpers

    private func handleChanges(_ changes: ChangesSnapshot<Decision>) {
        switch changes {
        case .initial:
            tableViewChangesHandler?(.initial)

        case let .modify(changes: info):
            let tableViewChanges = TableViewChanges.update(info: TableViewChanges.Info(
                insertedIndexes: info.insertedIndexes,
                deletedIndexes: info.deletedIndexes,
                updatedIndexes: info.modifiedIndexes)
            )
            tableViewChangesHandler?(tableViewChanges)
        case let .error(error):
            print("Updation error: \(String(describing: error))")
        }
    }
}
