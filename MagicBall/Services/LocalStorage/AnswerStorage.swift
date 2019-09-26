//
//  AnswerStorage.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 An object which will provide storage for user's answer.
 */
protocol AnswerStorage {

    /// Indicates whether initial answers were setted.
    var isInititalConfigured: Bool { get set }
    /// Saved custom user's answers.
    var answers: [String] { get }

    /// Add new user's answer to storage.
    func addAnswers(_ answers: [String])
    /// Remove answer from storage.
    func removeAnswer(_ answer: String)

}

extension UserDefaults: AnswerStorage {

    var isInititalConfigured: Bool {
        get {
            bool(forKey: Constants.isInitialConfigured)
        }
        set {
            set(newValue, forKey: Constants.isInitialConfigured)
        }
    }

    var answers: [String] {
        get {
            stringArray(forKey: Constants.answers) ?? []
        }
        set {
            set(newValue, forKey: Constants.answers)
        }
    }

    func addAnswers(_ newAnswers: [String]) {
        answers += newAnswers
    }

    func removeAnswer(_ answer: String) {
        answers = answers.filter({ $0 != answer })
    }

}
