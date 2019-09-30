//
//  MainViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

private extension MainViewController {

    enum Defaults {
        // Answer container
        static let answerContainerCornerRadius: CGFloat = 10.0
        // Answer label
        static let answerLabelDefaultText: String = "Try me!"
    }

}

final class MainViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private weak var answerLabel: UILabel!
    @IBOutlet private weak var answerContainer: UIView!
    @IBOutlet private weak var ballImageView: UIImageView!
    @IBOutlet private weak var settingsButton: UIBarButtonItem!

    // MARK: - Private properties

    private var viewModel: MainViewModel!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    // MARK: - Dependency injection

    func setViewModel(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Configure

    private func configure() {
        configureAnswerContainer()
        configureAnswerLabel()
        configureBallImageView()
        configureSettingsButton()
    }

    private func configureAnswerContainer() {
        answerContainer.layer.cornerRadius = Defaults.answerContainerCornerRadius
    }

    private func configureAnswerLabel() {
        answerLabel.text = Defaults.answerLabelDefaultText
    }

    private func configureBallImageView() {
        ballImageView.image = Asset.ball.image
    }

    private func configureSettingsButton() {
        let settingsImage = Asset.settings.image
        settingsButton.image = settingsImage
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
        animateAnswerAppearance(with: Defaults.answerLabelDefaultText)
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
