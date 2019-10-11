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
        let initialConfigurator: InitialConfigurator = InitialConfigurationManager()
        initialConfigurator.presetAnswers()

        window = UIWindow(frame: UIScreen.main.bounds)

        let initialTabBar = prepareInitialTabBar()

        window?.rootViewController = initialTabBar
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - InitialTabBar

    private func prepareInitialTabBar() -> UITabBarController {
        let mainViewController = prepareMainViewController()
        let mainTitle = L10n.Main.tabBarItemTitle
        let mainImage = Asset.Images.ballIcon.image
        let mainTabBarItem = UITabBarItem(title: mainTitle, image: mainImage, selectedImage: nil)
        mainViewController.tabBarItem = mainTabBarItem

        let answerListViewController = prepareAnswerListViewController()
        let answerListTitle = L10n.AnswerList.tabBarItemTitle
        let answerListImage = Asset.Images.listIcon.image
        let answerListTabBarItem = UITabBarItem(title: answerListTitle, image: answerListImage, selectedImage: nil)
        answerListViewController.tabBarItem = answerListTabBarItem

        let inititalTabBar = UITabBarController()
        inititalTabBar.viewControllers = [mainViewController, answerListViewController]

        return inititalTabBar
    }

    // MARK: - Main flow

    private func prepareMainViewController() -> MainViewController {
        let mainViewModel = prepareMainViewModel()
        let mainViewController = MainViewController(viewModel: mainViewModel)

        return mainViewController
    }

    private func prepareMainViewModel() -> MainViewModel {
        let mainModel = prepareMainModel()
        let mainViewModel = MainViewModel(model: mainModel)

        return mainViewModel
    }

    private func prepareMainModel() -> MainModel {
        let networkManager = NetworkManager()
        let onDeviceMagicBall = OnDeviceMagicBall()
        let shakeCounter = MagicBallShakeCounter()
        let mainModel = MainModel(
            networkManager: networkManager,
            onDeviceMagicBall: onDeviceMagicBall,
            shakeCounter: shakeCounter
        )

        return mainModel
    }

     // MARK: - AnswerList flow

       private func prepareAnswerListViewController() -> AnswerListViewController {
           let answerListViewModel = prepareAnswerListViewModel()
           let answerListViewController = AnswerListViewController(viewModel: answerListViewModel)

           return answerListViewController
       }

       private func prepareAnswerListViewModel() -> AnswerListViewModel {
           let answerListModel = prepareAnswerListModel()
           let answerListViewModel = AnswerListViewModel(model: answerListModel)

           return answerListViewModel
       }

       private func prepareAnswerListModel() -> AnswerListModel {
           let decisionStorage = UserDefaults.standard
           let answerListModel = AnswerListModel(decisionStorage: decisionStorage)

           return answerListModel
       }
}
