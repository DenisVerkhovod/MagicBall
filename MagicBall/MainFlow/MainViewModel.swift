//
//  MainViewModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import RxSwift

final class MainViewModel {

    // MARK: - Public properties

    let shakeEventWasStarted = PublishSubject<Void>()
    let shakeEventWasFinished = PublishSubject<Void>()
    let shakeEventWasCanceled = PublishSubject<Void>()

    var presentableDecision: Observable<PresentableDecision> {
        return model
            .decisionToCommit
            .asObservable()
            .filter({ $0 != nil })
            .map({ $0!.toPresentableDecision() })
    }

    var totalShakes: Observable<String> {
        return model
            .totalShakes
            .asObservable()
            .map(String.init)
            .map({ L10n.Main.totalShakes + $0 })
    }

    // MARK: - Private properties

    private let model: MainModel
    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(model: MainModel) {
        self.model = model

        shakeEventWasStarted
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.model.loadAnswer()
                self?.model.increaseShakesCounter()
            })
            .disposed(by: disposeBag)

        shakeEventWasFinished
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.model.commitDecision()
            })
            .disposed(by: disposeBag)

        shakeEventWasCanceled
            .asObservable()
            .subscribe(onNext: { [weak self] in
                self?.model.cancelLoading()
            })
            .disposed(by: disposeBag)
    }
}
