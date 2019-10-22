//
//  AppDelegate.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/26/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let answerStorage = makeCoreDataManager()
        let initialConfigurator: InitialConfigurator = InitialConfigurationManager(answerStorage: answerStorage)
        initialConfigurator.presetAnswers()

        window = UIWindow(frame: UIScreen.main.bounds)

        let animator = Animator()
        let initialTabBar = makeInitialTabBar(with: answerStorage, animator: animator)

        window?.rootViewController = initialTabBar
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - InitialTabBar

    private func makeInitialTabBar(with storage: DecisionStorage, animator: MagicBallAnimator) -> UITabBarController {
        let mainViewController = makeMainViewController(with: storage, animator: animator)
        let mainTitle = L10n.Main.tabBarItemTitle
        let mainImage = Asset.Images.ballIcon.image
        let mainTabBarItem = UITabBarItem(title: mainTitle, image: mainImage, selectedImage: nil)
        mainViewController.tabBarItem = mainTabBarItem

        let answerListViewController = makeAnswerListViewController(with: storage, animator: animator)
        let answerListTitle = L10n.AnswerList.tabBarItemTitle
        let answerListImage = Asset.Images.listIcon.image
        let answerListTabBarItem = UITabBarItem(title: answerListTitle, image: answerListImage, selectedImage: nil)
        answerListViewController.tabBarItem = answerListTabBarItem

        let inititalTabBar = UITabBarController()
        inititalTabBar.viewControllers = [mainViewController, answerListViewController]

        return inititalTabBar
    }

    // MARK: - Main flow

    private func makeMainViewController(
        with storage: DecisionStorage,
        animator: MagicBallAnimator
    ) -> MainViewController {
        let mainViewModel = makeMainViewModel(with: storage)
        let mainViewController = MainViewController(viewModel: mainViewModel, animator: animator)

        return mainViewController
    }

    private func makeMainViewModel(with storage: DecisionStorage) -> MainViewModel {
        let mainModel = makeMainModel(with: storage)
        let mainViewModel = MainViewModel(model: mainModel)

        return mainViewModel
    }

    private func makeMainModel(with storage: DecisionStorage) -> MainModel {
        let networkManager = NetworkManager()
        let shakeCounter = MagicBallShakeCounter()
        let onDeviceMagicBall = OnDeviceMagicBall(answerStorage: storage)

        let mainModel = MainModel(
            networkManager: networkManager,
            onDeviceMagicBall: onDeviceMagicBall,
            shakeCounter: shakeCounter,
            decisionStorage: storage
        )

        return mainModel
    }

    // MARK: - AnswerList flow

    private func makeAnswerListViewController(
        with storage: DecisionStorage,
        animator: MagicBallAnimator
    ) -> AnswerListViewController {
        let answerListViewModel = makeAnswerListViewModel(with: storage)
        let answerListViewController = AnswerListViewController(viewModel: answerListViewModel, animator: animator)

        return answerListViewController
    }

    private func makeAnswerListViewModel(with storage: DecisionStorage) -> AnswerListViewModel {
        let answerListModel = makeAnswerListModel(with: storage)
        let answerListViewModel = AnswerListViewModel(model: answerListModel)

        return answerListViewModel
    }

    private func makeAnswerListModel(with storage: DecisionStorage) -> AnswerListModel {
        let answerListModel = AnswerListModel(decisionStorage: storage)

        return answerListModel
    }

    // MARK: - Helpers

    private func makeCoreDataManager() -> CoreDataManager {
        let coreDataStack = CoreDataStack(modelName: Constants.CoreData.modelName)

        return CoreDataManager(coreDataStack: coreDataStack)
    }
}
