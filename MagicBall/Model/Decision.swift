//
//  Decision.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

struct Decision: Decodable {

    let answer: String

    enum CodingKeys: String, CodingKey {
        case answer
    }

    enum MagicCodingKeys: String, CodingKey {
        case magic
    }

    init(from decoder: Decoder) throws {
        let magicContainer = try decoder.container(keyedBy: MagicCodingKeys.self)
        let decisionContainer = try magicContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .magic)
        answer = try decisionContainer.decode(String.self, forKey: .answer)
    }

    init(answer: String) {
        self.answer = answer
    }
}
