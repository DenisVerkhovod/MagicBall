//
//  Constants.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

struct Constants {
    static let defaultAnswer: String = "Try again later!"
    static let animationDuration: TimeInterval = 1.0

    // User defaults constants
    static let answers: String = "answers"
    static let isInitialConfigured: String = "isInitialConfigured"
    static let presetAnswers: [String] =
        [
            "Great idea!",
            "Let's do it!",
            "Not now",
            "Maybe next time"
    ]
}
