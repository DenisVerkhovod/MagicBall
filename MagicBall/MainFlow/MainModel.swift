//
//  MainModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

final class MainModel {

    // MARK: - Private properties

    private let networkManager: NetworkManagerProtocol
    private let onDeviceMagicBall: AnswerGenerator
    private var decision: Decision? {
        didSet {
            guard let decision = decision else { return }
            onGettingDecision?(decision)
        }
    }
    private var onGettingDecision: ((Decision) -> Void)?
    private var dataTask: URLSessionDataTask?

    // MARK: - Inititalization

    init(networkManager: NetworkManagerProtocol, onDeviceMagicBall: AnswerGenerator) {
        self.networkManager = networkManager
        self.onDeviceMagicBall = onDeviceMagicBall
    }

    // MARK: - Answer handlers

    func loadAnswer() {
        invalidateDecision()
        dataTask = networkManager.getAnswer { [weak self] result in
            switch result {
            case let .success(decision):
                self?.decision = decision

            case .failure:
                self?.decision = self?.onDeviceMagicBall.generateAnswer()
            }
        }
    }

    func getAnswer(_ completion: @escaping (Decision) -> Void) {
        if let decision = decision {
            completion(decision)
        } else {
            onGettingDecision = completion
        }
    }

    func cancelLoading() {
        dataTask?.cancel()
        dataTask = nil
    }

    // MARK: - Helpers

    private func invalidateDecision() {
        cancelLoading()
        decision = nil
        onGettingDecision = nil
    }
}
