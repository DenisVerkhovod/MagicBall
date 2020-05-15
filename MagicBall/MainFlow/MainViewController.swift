//
//  MainViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseViewController<MainViewControllerView> {

    // MARK: - Private properties

    private let viewModel: MainViewModel
    private let animator: BallAnimator = MagicBallAnimator()
    private let disposeBag = DisposeBag()
    private let shakeEventWasStarted = PublishSubject<Void>()
    private let shakeEventWasFinished = PublishSubject<Void>()
    private let shakeEventWasCanceled = PublishSubject<Void>()

    // MARK: - Lifecycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    // MARK: - Configure

    private func setupBindings() {
        viewModel
            .presentableDecision
            .map({ $0.answer })
            .subscribe(onNext: { [weak self] answer in
                self?.stopAnswerWaitingAnimation(completion: {
                    self?.animateAnswerPresenting(with: answer)
                })
            })
            .disposed(by: disposeBag)

        viewModel
            .totalShakes
            .bind(to: rootView.totalShakesLabel.rx.text )
            .disposed(by: disposeBag)

        shakeEventWasStarted
            .bind(to: viewModel.shakeEventWasStarted)
            .disposed(by: disposeBag)

        shakeEventWasFinished
            .bind(to: viewModel.shakeEventWasFinished)
            .disposed(by: disposeBag)

        shakeEventWasCanceled
            .bind(to: viewModel.shakeEventWasCanceled)
            .disposed(by: disposeBag)

    }

    // MARK: - Shake handlers

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        shakeEventWasStarted.onNext(())
        startAnswerWaitingAnimation()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        shakeEventWasFinished.onNext(())
    }

    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        shakeEventWasCanceled.onNext(())
        stopAnswerWaitingAnimation { [weak self] in
            self?.animateAnswerPresenting(with: L10n.Main.answerLabelDefaultText)
        }
    }

    // MARK: - Animation

    private func animateAnswerPresenting(with text: String) {
        animator.answerPresentingAnimation(in: rootView.answerTextView, with: text)
    }

    private func startAnswerWaitingAnimation() {
        animator.startPulsation(for: rootView.ballContainer)
    }

    private func stopAnswerWaitingAnimation(completion: @escaping () -> Void) {
        animator.stopPulsation(for: rootView.ballContainer, completion: completion)
    }
}
