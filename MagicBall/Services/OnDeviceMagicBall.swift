//
//  OnDeviceMagicBall.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 An object that generate random answers
 */
final class OnDeviceMagicBall {
    private let localStorage: LocalStorageProtocol
    
    init(localStorage: LocalStorageProtocol = LocalStorageManager()) {
        self.localStorage = localStorage
    }
    
    /**
     Generate random answer
     
     - Returns: Decision with random answer
     */
    func generateAnswer() -> Decision {
        let generatedAnswer = localStorage.answers.randomElement() ?? Constants.defaultAnswer
        return Decision(answer: generatedAnswer)
    }
}
