//
//  PresentableDecision.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/29/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

struct PresentableDecision {

    let answer: String
    var removingHandler: (() -> Void)?
}
