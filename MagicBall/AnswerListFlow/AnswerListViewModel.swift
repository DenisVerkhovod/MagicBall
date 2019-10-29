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

    let newAnswer = PublishRelay<String>()
    let removeDecision = PublishRelay<String>()
    var decisionsSections: Observable<[DecisionsSection]> {
        return model
            .decisions
            .asObservable()
            .map({ $0.toDecisionsSections() })
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
                self?.model.save([decision])
            })
            .disposed(by: disposeBag)

        removeDecision
            .asObservable()
            .subscribe(onNext: { [weak self] identifier in
                self?.model.removeDecision(with: identifier)
            })
            .disposed(by: disposeBag)
    }
}
