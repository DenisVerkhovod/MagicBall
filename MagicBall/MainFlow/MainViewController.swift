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

        // Answer container
        static let answerContainerCornerRadius: CGFloat = 10.0
        static let answerContainerWidthMultiplier: CGFloat = 0.6
        static let answerContainerHeightMultiplier: CGFloat = 0.2

        // Answer label
        static let answerLabelFontSize: CGFloat = 26.0
        static let answerLabelEdgeOffset: CGFloat = 5.0
    }

}

final class MainViewController: BaseViewController {

    // MARK: - Private properties

    private var viewModel: MainViewModel

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

    private lazy var ballImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Images.ball.image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        return imageView
    }()

    private lazy var answerContainer: UIView = {
        let containerView = UIView()
        containerView.layer.cornerRadius = Defaults.answerContainerCornerRadius
        containerView.backgroundColor = Asset.Colors.mainBlue.color
        ballImageView.addSubview(containerView)

        return containerView
    }()

    private lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Defaults.answerLabelFontSize)
        label.textColor = Asset.Colors.turquoise.color
        label.text = L10n.Main.answerLabelDefaultText
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        answerContainer.addSubview(label)

        return label
    }()

    private lazy var settingsButton: UIBarButtonItem = {
        let image = Asset.Images.settings.image
        let barButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(settingsButtonDidTapped(_:))
        )
        barButton.tintColor = Asset.Colors.tintBlue.color

        return barButton
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
        configureNavigationItem()
        updateTotalShakesLabel()
    }

    private func configureView() {
        view.backgroundColor = Asset.Colors.mainBlue.color
    }

    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = settingsButton
    }

    // MARK: - Setup views

    private func setupViews() {
        setupTitleLabel()
        setupTotalShakesLabel()
        setupBallImageView()
        setupAnswerContainer()
        setupAnswerLabel()
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

    private func setupBallImageView() {
        ballImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(totalShakesLabel.snp.bottom).offset(Defaults.ballContainerTopOffset)
            make.leading.trailing.equalTo(titleLabel)
            make.centerY.equalToSuperview().priority(.medium)
            make.width.equalTo(ballImageView.snp.height).multipliedBy(1)
        }
    }

    private func setupAnswerContainer() {
        answerContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Defaults.answerContainerWidthMultiplier)
            make.height.equalToSuperview().multipliedBy(Defaults.answerContainerHeightMultiplier)
        }
    }

    private func setupAnswerLabel() {
        answerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Defaults.answerLabelEdgeOffset)
        }
    }

    // MARK: - Shake handlers

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        animateAnswerDismissing()
        viewModel.handleShake()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        viewModel.getAnswer { [weak self] presentableDecision in
            self?.animateAnswerAppearance(with: presentableDecision.answer)
        }
        viewModel.increaseShakesCounter()
        updateTotalShakesLabel()
    }

    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }

        viewModel.handleShakeCancelling()
        animateAnswerAppearance(with: L10n.Main.answerLabelDefaultText)
    }

    // MARK: - Actions

    @objc private func settingsButtonDidTapped(_ sender: UIBarButtonItem) {
        let settingsViewController = prepareSettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }

    // MARK: - Helpers

    /**
     Animate answerLabel appearance with given text.
     
     - Parameter text: Text to assign to label.
     */
    private func animateAnswerAppearance(with text: String) {
        answerLabel.text = text
        UIView.animate(withDuration: Constants.animationDuration) {
            self.answerLabel.alpha = 1.0
        }
    }

    /**
     Animate answerLabel dismissing
     */
    private func animateAnswerDismissing() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.answerLabel.alpha = 0.0
        }
    }

    private func updateTotalShakesLabel() {
        totalShakesLabel.text = L10n.Main.totalShakes + "\(viewModel.totalShakes)"
    }

    // MARK: - Settings flow

    private func prepareSettingsViewController() -> SettingsViewController {
        let settingViewModel = prepareSettingsViewModel()
        let settingsViewController = SettingsViewController(viewModel: settingViewModel)

        return settingsViewController
    }

    private func prepareSettingsViewModel() -> SettingsViewModel {
        let settingsModel = prepareSettingsModel()
        let settingsViewModel = SettingsViewModel(model: settingsModel)

        return settingsViewModel
    }

    private func prepareSettingsModel() -> SettingsModel {
        let decisionStorage = UserDefaults.standard
        let settingsModel = SettingsModel(decisionStorage: decisionStorage)

        return settingsModel
    }
}
