//
//  MainFlowCoordinator.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 28.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

final class MainFlowCoordinator: NavigationNode, FlowCoordinator {

    weak var containerViewController: UIViewController?

    private let networkManager: NetworkManagerProtocol
    private let onDeviceMagicBall: AnswerGenerator
    private let shakeCounter: ShakeCounter
    private let decisionStorage: DecisionStorage

    init(
        parent: NavigationNode,
        networkManager: NetworkManagerProtocol,
        onDeviceMagicBall: AnswerGenerator,
        shakeCounter: ShakeCounter,
        decisionStorage: DecisionStorage
    ) {
        self.networkManager = networkManager
        self.onDeviceMagicBall = onDeviceMagicBall
        self.shakeCounter = shakeCounter
        self.decisionStorage = decisionStorage

        super.init(parent: parent)
    }

    func createFlow() -> UIViewController {
        let mainModel = MainModel(
            parent: self,
            networkManager: networkManager,
            onDeviceMagicBall: onDeviceMagicBall,
            shakeCounter: shakeCounter,
            decisionStorage: decisionStorage
        )
        let mainViewModel = MainViewModel(model: mainModel)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        let mainTitle = L10n.Main.tabBarItemTitle
        let mainImage = Asset.Images.ballIcon.image
        let mainTabBarItem = UITabBarItem(title: mainTitle, image: mainImage, selectedImage: nil)
        mainViewController.tabBarItem = mainTabBarItem

        return mainViewController

    }
}
