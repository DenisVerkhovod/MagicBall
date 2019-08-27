//
//  LocalStorageManager.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 Abstraction for an object that will provide user's answers storing functionality.
 */
protocol LocalStorageProtocol {
    /// Saved custom user's answers
    var answers: [String] { get }
    /// Add new user's answer to storage
    func addAnswer(_ newAnswer: String)
    /// Remove answer from storage
    func removeAnswer(_ answer: String)
}

final class LocalStorageManager: LocalStorageProtocol {
    private let defaults: UserDefaults
    
    var answers: [String] {
        get {
            return defaults.stringArray(forKey: Constants.answers) ?? []
        }
        set {
            defaults.set(newValue, forKey: Constants.answers)
        }
    }
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func addAnswer(_ newAnswer: String) {
        let updatedAnswers = [newAnswer] + answers
        answers = updatedAnswers
    }
    
    func removeAnswer(_ answer: String) {
        answers = answers.filter({ $0 != answer })
    }
}
