//
//  StorableDecision.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

struct StorableDecision {

    let answer: String
}

// MARK: - Extension

extension StorableDecision {

    func toDecision() -> Decision {
        return Decision(answer: self.answer)
    }

}
