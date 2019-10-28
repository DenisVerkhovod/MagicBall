//
//  DecisionsSection.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 28.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import RxDataSources

struct DecisionsSection {
    var header: String
    var items: [PresentableDecision]
}

extension DecisionsSection: AnimatableSectionModelType {

    typealias Identity = Int
    typealias Item = PresentableDecision

    var identity: Int {
        return header.hashValue
      }

    init(original: DecisionsSection, items: [Item]) {
        self = original
        self.items = items
    }

}

extension PresentableDecision: IdentifiableType {

    typealias Identity = String

    var identity: String {
         return identifier
     }

}
