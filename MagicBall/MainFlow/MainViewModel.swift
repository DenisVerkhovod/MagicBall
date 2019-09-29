//
//  MainViewModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

final class MainViewModel {

    // MARK: - Private properties

    private let model: MainModel

    // MARK: - Inititalization

    init(model: MainModel) {
        self.model = model
    }

    // MARK: - Event handlers

    func shakeWasOccured() {
        model.loadAnswer()
    }

    func shakeWasCancelled() {
        model.cancelLoading()
    }

    func getAnswer(_ completion: @escaping (PresentableDecision) -> Void) {
        model.getAnswer { decision in
            completion(decision.toPresentableDecision())
        }
    }
}
