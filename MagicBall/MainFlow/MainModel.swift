//
//  MainModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class MainModel {

    // MARK: - Public properties

    var decisionToCommit: BehaviorRelay<Decision?>
    var totalShakes: BehaviorRelay<Int>

    // MARK: - Private properties

    private let networkManager: NetworkManagerProtocol
    private let onDeviceMagicBall: AnswerGenerator
    private let shakeCounter: ShakeCounter
    private let decisionStorage: DecisionStorage
    private var dataTask: URLSessionDataTask?
    private var decision: BehaviorRelay<Decision?>
    private var canCommitDecision: BehaviorRelay<Bool>
    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(
        networkManager: NetworkManagerProtocol,
        onDeviceMagicBall: AnswerGenerator,
        shakeCounter: ShakeCounter,
        decisionStorage: DecisionStorage
    ) {
        self.networkManager = networkManager
        self.onDeviceMagicBall = onDeviceMagicBall
        self.shakeCounter = shakeCounter
        self.decisionStorage = decisionStorage
        self.totalShakes = BehaviorRelay(value: shakeCounter.numberOfShakes)
        self.decision = BehaviorRelay(value: nil)
        self.canCommitDecision = BehaviorRelay(value: false)
        self.decisionToCommit = BehaviorRelay(value: nil)

        configureObservables()
    }

    // MARK: - Answer handlers

    func loadAnswer() {
        invalidateDecision()
        dataTask = networkManager.getAnswer { [weak self] result in
            var newDecision: Decision?
            switch result {
            case let .success(decision):
                newDecision = decision
                self?.decisionStorage.saveDecisions([decision])

            case .failure:
                newDecision = self?.onDeviceMagicBall.generateAnswer()
            }
            self?.decision.accept(newDecision)
        }
    }

    func commitAnswer() {
        canCommitDecision.accept(true)
    }

    func cancelLoading() {
        dataTask?.cancel()
        dataTask = nil
    }

    // MARK: - Shake count handlers

    func increaseShakesCounter() {
        shakeCounter.increaseCounter()
        totalShakes.accept(shakeCounter.numberOfShakes)
    }

    // MARK: - Configure

    private func configureObservables() {
        Observable.combineLatest(decision, canCommitDecision)
                .filter({ $0 != nil && $1 })
                .flatMap { decision, _ -> Observable<Decision?> in
                    return Observable.just(decision)
            }
            .subscribe(onNext: { [weak self] decision in
                self?.decisionToCommit.accept(decision)
            })
                .disposed(by: disposeBag)
    }

    // MARK: - Helpers

    private func invalidateDecision() {
        cancelLoading()
        decision.accept(nil)
        canCommitDecision.accept(false)
    }
}
