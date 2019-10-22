//
//  Constants.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

struct Constants {

    static let presetAnswers: [String] =
        [
            L10n.Answer.preset1,
            L10n.Answer.preset2,
            L10n.Answer.preset3,
            L10n.Answer.preset4
    ]

    // MARK: - Keychain constants

    struct Keychain {
        static let totalShakes: String = "totalShakes"
    }

    // MARK: - User defaults constants

    struct UserDefaults {
        static let answers: String = "answers"
        static let isInitialConfigured: String = "isInitialConfigured"
    }

    // MARK: - CoreData constants

    struct CoreData {
        static let modelName: String = "MagicBall"
    }

    // MARK: - Animation constants

    struct Animation {
        static let borderColor: String = "borderColor"
        static let transform: String = "transform"
        static let presentAnswer: String = "presentAnswer"
        static let successInput: String = "successInput"
        static let failedInput: String = "failedInput"
    }
}
