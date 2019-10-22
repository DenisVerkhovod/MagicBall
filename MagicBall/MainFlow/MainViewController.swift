//
//  MainViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit
import SnapKit

private extension MainViewController {

    enum Defaults {
        // Title label
        static let titleLabelFontSize: CGFloat = 36.0
        static let titleLabelTopOffset: CGFloat = 10.0
        static let titleLabelLeadingTrailingOffset: CGFloat = 20.0

        // Total shakes label
        static let totalShakesLabelFontSize: CGFloat = 17.0
        static let totalShakesLabelTopOffset: CGFloat = 10.0

        // Ball container
        static let ballContainerTopOffset: CGFloat = 10.0

        // Ball background view
        static let ballBackgroundSizeDivider: CGFloat = 2.0
        static let ballBackgroundViewZPosition: CGFloat = -1000.0

        // Ball image view
        static let ballImageViewZPosition: CGFloat = 1000.0

        // Answer text view
        static let answerTextViewPreferredFontSize: CGFloat = 21.0
        static let answerTextViewMinimumFontSize: CGFloat = 12.0
        static let answerTextViewHeightMultiplier: CGFloat = 0.35
    }

}

final class MainViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: MainViewModel
    private let animator: BallAnimator = MagicBallAnimator()

    // MARK: - Lazy properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Defaults.titleLabelFontSize)
        label.textColor = Asset.Colors.biege.color
        label.text = L10n.Main.title
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)

        return label
    }()

    private lazy var totalShakesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Defaults.totalShakesLabelFontSize)
        label.textColor = Asset.Colors.biege.color
        label.text = L10n.Main.totalShakes
        view.addSubview(label)

        return label
    }()

    private lazy var ballContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        view.addSubview(container)

        return container
    }()

    private lazy var ballBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = Asset.Colors.black.color
        backgroundView.layer.zPosition = Defaults.ballBackgroundViewZPosition
        ballContainer.insertSubview(backgroundView, at: 0)

        return backgroundView
    }()

    private lazy var answerTextView: TriangleTextView = {
        let answerView = TriangleTextView()
        answerView.minimumFontSize = Defaults.answerTextViewMinimumFontSize
        answerView.preferredFontSize = Defaults.answerTextViewPreferredFontSize
        answerView.setMainColor(Asset.Colors.gradientBlue.color)
        answerView.textColor = Asset.Colors.turquoise.color
        answerView.text = L10n.Main.answerLabelDefaultText
        ballContainer.insertSubview(answerView, aboveSubview: ballBackgroundView)

        return answerView
    }()

    private lazy var ballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Images.ball.image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.zPosition = Defaults.ballImageViewZPosition
        ballContainer.insertSubview(imageView, aboveSubview: answerTextView)

        return imageView
    }()

    // MARK: - Inititalization

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupViews()
    }

    // MARK: - Configure

    private func configure() {
        configureView()
        updateTotalShakesLabel()
    }

    private func configureView() {
        view.backgroundColor = Asset.Colors.mainBlue.color
    }

    // MARK: - Setup views

    private func setupViews() {
        setupTitleLabel()
        setupTotalShakesLabel()
        setupBallContainer()
        setupBallBackgroundView()
        setupBallImageView()
        setupAnswerTextView()
    }

    private func setupTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Defaults.titleLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(Defaults.titleLabelLeadingTrailingOffset)
        }
    }

    private func setupTotalShakesLabel() {
        totalShakesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Defaults.totalShakesLabelTopOffset)
        }
    }

    private func setupBallContainer() {
        ballContainer.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(totalShakesLabel.snp.bottom).offset(Defaults.ballContainerTopOffset)
            make.leading.trailing.equalTo(titleLabel)
            make.centerY.equalToSuperview().priority(.medium)
            make.width.equalTo(ballImageView.snp.height).multipliedBy(1)
        }
    }

    private func setupBallBackgroundView() {
        ballBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().dividedBy(Defaults.ballBackgroundSizeDivider)
        }
    }

    private func setupBallImageView() {
        ballImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupAnswerTextView() {
        answerTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(answerTextView.snp.height)
            make.height.equalToSuperview().multipliedBy(Defaults.answerTextViewHeightMultiplier)
        }
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
        totalShakesLabel.text = L10n.Main.totalShakes + "\(viewModel.totalShakes)"
    }

    // MARK: - Animation

    private func animateAnswerPresenting(with text: String) {
        animator.answerPresentingAnimation(in: answerTextView, with: text)
    }

    private func startAnswerWaitingAnimation() {
        animator.startPulsation(for: ballContainer)
    }

    private func stopAnswerWaitingAnimation(completion: @escaping () -> Void) {
        animator.stopPulsation(for: ballContainer, completion: completion)
    }
}
