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
        let answerStorage = prepareCoreDataManager()
        let initialConfigurator: InitialConfigurator = InitialConfigurationManager(answerStorage: answerStorage)
        initialConfigurator.presetAnswers()

        window = UIWindow(frame: UIScreen.main.bounds)

        let initialTabBar = prepareInitialTabBar(with: answerStorage)

        window?.rootViewController = initialTabBar
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - InitialTabBar

    private func prepareInitialTabBar(with storage: DecisionStorage) -> UITabBarController {
        let mainViewController = prepareMainViewController(with: storage)
        let mainTitle = L10n.Main.tabBarItemTitle
        let mainImage = Asset.Images.ballIcon.image
        let mainTabBarItem = UITabBarItem(title: mainTitle, image: mainImage, selectedImage: nil)
        mainViewController.tabBarItem = mainTabBarItem

        let answerListViewController = prepareAnswerListViewController(with: storage)
        let answerListTitle = L10n.AnswerList.tabBarItemTitle
        let answerListImage = Asset.Images.listIcon.image
        let answerListTabBarItem = UITabBarItem(title: answerListTitle, image: answerListImage, selectedImage: nil)
        answerListViewController.tabBarItem = answerListTabBarItem

        let inititalTabBar = UITabBarController()
        inititalTabBar.viewControllers = [mainViewController, answerListViewController]

        return inititalTabBar
    }

    // MARK: - Main flow

    private func prepareMainViewController(with storage: DecisionStorage) -> MainViewController {
        let mainViewModel = prepareMainViewModel(with: storage)
        let mainViewController = MainViewController(viewModel: mainViewModel)

        return mainViewController
    }

    private func prepareMainViewModel(with storage: DecisionStorage) -> MainViewModel {
        let mainModel = prepareMainModel(with: storage)
        let mainViewModel = MainViewModel(model: mainModel)

        return mainViewModel
    }

    private func prepareMainModel(with storage: DecisionStorage) -> MainModel {
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

    private func prepareAnswerListViewController(with storage: DecisionStorage) -> AnswerListViewController {
           let answerListViewModel = prepareAnswerListViewModel(with: storage)
           let answerListViewController = AnswerListViewController(viewModel: answerListViewModel)

           return answerListViewController
       }

    private func prepareAnswerListViewModel(with storage: DecisionStorage) -> AnswerListViewModel {
           let answerListModel = prepareAnswerListModel(with: storage)
           let answerListViewModel = AnswerListViewModel(model: answerListModel)

           return answerListViewModel
       }

    private func prepareAnswerListModel(with storage: DecisionStorage) -> AnswerListModel {
           let answerListModel = AnswerListModel(decisionStorage: storage)

           return answerListModel
       }

    // MARK: - Helpers

    private func prepareCoreDataManager() -> CoreDataManager {
        let coreDataStack = CoreDataStack(modelName: Constants.modelName)

        return CoreDataManager(coreDataStack: coreDataStack)
    }
}
