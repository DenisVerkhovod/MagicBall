//
//  AnswerListViewModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/30/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import RxSwift

final class AnswerListViewModel {

    // MARK: - Public properties

    var decisionsChanges: Observable<TableViewChanges> {
        return model
            .decisionsChanges
            .asObservable()
            .map({ $0.toTableViewChanges() })
    }

    var newAnswer = PublishSubject<String>()
    var numberOfDecisions: Int {
        return model.numberOfDecisions
    }

    // MARK: - Private properties

    private let model: AnswerListModel
    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(model: AnswerListModel) {
        self.model = model

        newAnswer
            .asObservable()
            .flatMap({ Observable<Decision>.just(Decision(answer: $0)) })
            .subscribe(onNext: { [weak self] decision in
                self?.saveDecision(decision)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Decision handlers

    func decision(at index: Int) -> PresentableDecision {
        let decision = model.decision(at: index)
        var presentableDecision = decision.toPresentableDecision()
        presentableDecision.removingHandler = { [weak self] in
            self?.model.remove(decision)
        }

        return presentableDecision
    }

    private func saveDecision(_ decision: Decision) {
        model.save([decision])
    }
}
