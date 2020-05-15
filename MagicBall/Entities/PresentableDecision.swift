//
//  PresentableDecision.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

struct PresentableDecision {

    let identifier: String
    let answer: String
    let createdAt: String
    var removingHandler: (() -> Void)?
}

extension PresentableDecision: Equatable {

    static func == (lhs: PresentableDecision, rhs: PresentableDecision) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
