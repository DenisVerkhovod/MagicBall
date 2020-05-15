//
//  AnswerListFlowCoordinator.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 28.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

final class AnswerListFlowCoordinator: NavigationNode, FlowCoordinator {

    weak var containerViewController: UIViewController?

    private let decisionStorage: DecisionStorage

    init(parent: NavigationNode, decisionStorage: DecisionStorage) {
        self.decisionStorage = decisionStorage

        super.init(parent: parent)
    }

    func createFlow() -> UIViewController {
        let answerListModel = AnswerListModel(parent: self, decisionStorage: decisionStorage)
        let answerListViewModel = AnswerListViewModel(model: answerListModel)
        let answerListViewController = AnswerListViewController(viewModel: answerListViewModel)
        let answerListTitle = L10n.AnswerList.tabBarItemTitle
        let answerListImage = Asset.Images.listIcon.image
        let answerListTabBarItem = UITabBarItem(title: answerListTitle, image: answerListImage, selectedImage: nil)
        answerListViewController.tabBarItem = answerListTabBarItem

        return answerListViewController
    }
}
