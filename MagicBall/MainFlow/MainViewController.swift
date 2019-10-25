//
//  MainViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

final class MainViewController: BaseViewController<MainViewControllerView> {

    // MARK: - Private properties

    private let viewModel: MainViewModel
    private let animator: BallAnimator = MagicBallAnimator()

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

        configure()
    }

    // MARK: - Configure

    private func configure() {
        updateTotalShakesLabel()
    }

    // MARK: - Shake handlers

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        startAnswerWaitingAnimation()
        viewModel.handleShake()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        viewModel.getAnswer { [weak self] presentableDecision in
            self?.stopAnswerWaitingAnimation(completion: { [weak self] in
                self?.animateAnswerPresenting(with: presentableDecision.answer)
            })
        }

        viewModel.increaseShakesCounter()
        updateTotalShakesLabel()
    }

    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        viewModel.handleShakeCancelling()
        animateAnswerPresenting(with: L10n.Main.answerLabelDefaultText)
    }

    // MARK: - Helpers

    private func updateTotalShakesLabel() {
        rootView.totalShakesLabel.text = L10n.Main.totalShakes + "\(viewModel.totalShakes)"
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
