//
//  AppCoordinator.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 28.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

final class AppCoordinator: NavigationNode, FlowCoordinator {

    weak var containerViewController: UIViewController?

    private let networkManager: NetworkManagerProtocol
    private let onDeviceMagicBall: AnswerGenerator
    private let shakeCounter: ShakeCounter
    private let decisionStorage: DecisionStorage

    init(
        parent: NavigationNode?,
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
        let mainCoordinator = MainFlowCoordinator(
            parent: self,
            networkManager: networkManager,
            onDeviceMagicBall: onDeviceMagicBall,
            shakeCounter: shakeCounter,
            decisionStorage: decisionStorage)
        let mainViewController = mainCoordinator.createFlow()
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        mainCoordinator.containerViewController = mainNavigationController

        let answerListCoordinator = AnswerListFlowCoordinator(
            parent: self,
            decisionStorage: decisionStorage)
        let answerListViewController = answerListCoordinator.createFlow()
        let answerListNavigationController = UINavigationController(rootViewController: answerListViewController)
        answerListCoordinator.containerViewController = answerListNavigationController

        let mainTabBar = UITabBarController()
        mainTabBar.viewControllers = [mainNavigationController, answerListNavigationController]

        return mainTabBar
    }
}
