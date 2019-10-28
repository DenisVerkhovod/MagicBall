//
//  MainModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import RxSwift

final class MainModel: NavigationNode {

    // MARK: - Public properties

    var decisionToCommit: BehaviorRelay<Decision?>
    var totalShakes: BehaviorRelay<Int>

    // MARK: - Private properties

    private let networkManager: NetworkManagerProtocol
    private let onDeviceMagicBall: AnswerGenerator
    private let shakeCounter: ShakeCounter
    private let decisionStorage: DecisionStorage
    private let disposeBag = DisposeBag()
    private var dataTask: URLSessionDataTask?
    private var decision: BehaviorRelay<Decision?>
    private var canCommitDecision: BehaviorRelay<Bool>

    // MARK: - Initialization

    init(
        parent: NavigationNode,
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

        super.init(parent: parent)

        Observable.combineLatest(decision, canCommitDecision)
            .filter({ $0 != nil && $1 })
            .subscribe(onNext: { [weak self] decision, _ in
                self?.decisionToCommit.accept(decision)
            })
            .disposed(by: disposeBag)
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

    func commitDecision() {
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

    // MARK: - Helpers

    private func invalidateDecision() {
        cancelLoading()
        decision.accept(nil)
        canCommitDecision.accept(false)
    }
}
