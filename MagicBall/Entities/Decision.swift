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
    let createdAt: Date
    let identifier: String

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
        createdAt = Date()
        identifier = UUID().uuidString
    }

    init(answer: String, createdAt: Date = Date(), identifier: String = UUID().uuidString) {
        self.answer = answer
        self.createdAt = createdAt
        self.identifier = identifier
    }
}

// MARK: - Extension

extension Decision {

    func toPresentableDecision() -> PresentableDecision {
        let dateFormatter = DateFormatter.fullDateFormatter
        let formattedDate = dateFormatter.string(from: createdAt)

        return PresentableDecision(identifier: identifier, answer: self.answer.uppercased(), createdAt: formattedDate)
    }

}
