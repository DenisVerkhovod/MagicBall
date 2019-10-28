//
//  Array + toDecisionsSection.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 28.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

extension Array where Element == Decision {

    /// Map an array of decisions into array of DecisionsSection
    /// which is appropriate for using with RxTableViewSectionedAnimatedDataSource.
    func toDecisionsSections(ascending: Bool = false) -> [DecisionsSection] {
        var sectionsDictinary: [String: [PresentableDecision]] = [:]
        forEach {
            let date = DateFormatter.monthYearDateFormatter.string(for: $0.createdAt) ?? ""
            if let sectionItems = sectionsDictinary[date] {
                sectionsDictinary[date] = sectionItems + [$0.toPresentableDecision()]
            } else {
                sectionsDictinary[date] = [$0.toPresentableDecision()]
            }

        }
        var sections: [DecisionsSection] = []
        sectionsDictinary.forEach {
            sections.append(DecisionsSection(header: $0, items: $1))
        }

        return sections
            .sorted { firstSection, secondSection in
                let formatter = DateFormatter.monthYearDateFormatter
                guard
                    let firstDate = formatter.date(from: firstSection.header),
                    let secondDate = formatter.date(from: secondSection.header)
                    else { return false }

                return ascending
                    ? firstDate < secondDate
                    : firstDate > secondDate
        }
    }

}
