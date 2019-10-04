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
        static let titleLabelTopOffset: CGFloat = 10.0
        static let titleLabelLeadingTrailingOffset: CGFloat = 20.0

        // BallContainer
        static let ballContainerTopOffset: CGFloat = 10.0

        // Answer container
        static let answerContainerCornerRadius: CGFloat = 10.0

        // Answer label
        static let answerLabelEdgeOffset: CGFloat = 5.0
    }

}

final class MainViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ballContainer: UIView!
    @IBOutlet private weak var ballImageView: UIImageView!
    @IBOutlet private weak var answerContainer: UIView!
    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var settingsButton: UIBarButtonItem!

    // MARK: - Private properties

    private var viewModel: MainViewModel!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupViews()
    }

    // MARK: - Dependency injection

    func setViewModel(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Configure

    private func configure() {
        configureView()
        configureTitleLabel()
        configureAnswerContainer()
        configureAnswerLabel()
        configureBallImageView()
        configureSettingsButton()
    }

    private func configureView() {
        view.backgroundColor = Asset.Colors.mainBlue.color
    }

    private func configureTitleLabel() {
        titleLabel.text = L10n.Main.title
        titleLabel.textColor = Asset.Colors.biege.color
    }

    private func configureAnswerContainer() {
        answerContainer.layer.cornerRadius = Defaults.answerContainerCornerRadius
        answerContainer.backgroundColor = Asset.Colors.mainBlue.color
    }

    private func configureAnswerLabel() {
        answerLabel.text = L10n.Main.answerLabelDefaultText
        answerLabel.textColor = Asset.Colors.turquoise.color
    }

    private func configureBallImageView() {
        ballImageView.image = Asset.Images.ball.image
    }

    private func configureSettingsButton() {
        let settingsImage = Asset.Images.settings.image
        settingsButton.image = settingsImage
        settingsButton.tintColor = Asset.Colors.tintBlue.color
    }

    // MARK: - Setup Views

    private func setupViews() {
        setupTitleLabel()
        setupBallContainer()
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

    private func setupBallContainer() {
        ballContainer.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleLabel).offset(Defaults.ballContainerTopOffset)
            make.leading.trailing.equalTo(titleLabel)
            make.centerY.equalToSuperview().priority(.medium)
        }
    }

    private func setupBallImageView() {
        ballImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(ballImageView.snp.height).multipliedBy(1)
        }
    }

    private func setupAnswerContainer() {
        answerContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.15)
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
    }

    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        viewModel.handleShakeCancelling()
        animateAnswerAppearance(with: L10n.Main.answerLabelDefaultText)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch StoryboardSegue.Main(segue) {
        case .settingsSegue:
            guard let settingsNavigationController = segue.destination as? UINavigationController else { return }
            let settingsViewController = prepareSettingsViewController()
            settingsNavigationController.setViewControllers([settingsViewController], animated: true)

        default:
            break
        }
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

    // MARK: - Settings flow

    private func prepareSettingsViewController() -> SettingsViewController {
        let settingsViewController = StoryboardScene.Main.settingsViewController.instantiate()
        let settingViewModel = prepareSettingsViewModel()
        settingsViewController.setViewModel(settingViewModel)

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
