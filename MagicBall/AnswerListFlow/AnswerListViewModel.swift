//
//  AnswerListViewModel.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 9/30/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation
import RxSwift

final class AnswerListViewModel {

    // MARK: - Public properties

    let newAnswer = PublishRelay<String>()
    let removeDecision = PublishRelay<String>()
    var decisionsSections: Observable<[DecisionsSection]> {
        return model
            .decisions
            .asObservable()
            .map({ $0.toDecisionsSections() })
    }

    // MARK: - Private properties

    private let model: AnswerListModel
    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(model: AnswerListModel) {
        self.model = model

        newAnswer
            .asObservable()
            .map({ Decision(answer: $0) })
            .subscribe(onNext: { [weak self] decision in
                self?.model.save([decision])
            })
            .disposed(by: disposeBag)

        removeDecision
            .asObservable()
            .subscribe(onNext: { [weak self] identifier in
                self?.model.removeDecision(with: identifier)
            })
            .disposed(by: disposeBag)
    }
}

private extension Array where Element == Decision {

    /// Map an array of decisions into array of DecisionsSection
    /// which is appropriate for using with RxTableViewSectionedAnimatedDataSource.
    func toDecisionsSections(ascending: Bool = false) -> [DecisionsSection] {
        var sectionsDictionary: [String: [PresentableDecision]] = [:]
        forEach {
            let date = DateFormatter.monthYearDateFormatter.string(for: $0.createdAt) ?? ""
            if let sectionItems = sectionsDictionary[date] {
                sectionsDictionary[date] = sectionItems + [$0.toPresentableDecision()]
            } else {
                sectionsDictionary[date] = [$0.toPresentableDecision()]
            }

        }
        var sections: [DecisionsSection] = []
        sectionsDictionary.forEach {
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
