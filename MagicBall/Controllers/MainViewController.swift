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
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerContainer: UIView!
    
    // MARK: - Private properties
    private let networkManager: NetworkManager = NetworkManager()
    private let onDeviceMagicBall: OnDeviceMagicBall = OnDeviceMagicBall()
    private var dataTask: URLSessionDataTask?
    private var onGettingAnswer: ((Decision) -> Void)?
    private var answer: String?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - Configure
    private func configure() {
        configureAnswerContainer()
        configureAnswerLabel()
    }
    
    private func configureAnswerContainer() {
        answerContainer.layer.cornerRadius = Defaults.answerContainerCornerRadius
    }
    
    private func configureAnswerLabel() {
        answerLabel.text = Defaults.answerLabelDefaultText
    }
    
    // MARK: - Shake handlers
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        prepareToMotion()
        getAnswer { decision in
            self.answer = decision.answer
            self.onGettingAnswer?(decision)
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        if let answer = answer {
            animateAnswerAppearance(with: answer)
        } else {
            onGettingAnswer = { [weak self] decision in
                self?.animateAnswerAppearance(with: decision.answer)
            }
        }
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        dataTask?.cancel()
        animateAnswerAppearance(with: Defaults.answerLabelDefaultText)
    }
    
    private func prepareToMotion() {
        onGettingAnswer = nil
        answer = nil
        animateAnswerDismissing()
    }
    
    // MARK: - Helpers
    private func getAnswer(completion: @escaping (Decision) -> Void) {
        dataTask = networkManager.getAnswer { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case let .success(decision):
                completion(decision)
            case .failure:
                completion(strongSelf.onDeviceMagicBall.generateAnswer())
            }
        }
    }
    
    private func animateAnswerAppearance(with text: String) {
        answerLabel.text = text
        UIView.animate(withDuration: Constants.animationDuration) {
            self.answerLabel.alpha = 1.0
        }
    }
    
    private func animateAnswerDismissing() {
        UIView.animate(withDuration: Constants.animationDuration) {
            self.answerLabel.alpha = 0.0
        }
    }
}

