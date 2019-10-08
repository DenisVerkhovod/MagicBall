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

        let mainViewController = prepareMainViewController()
        let initialNavigationController = UINavigationController(rootViewController: mainViewController)

        window?.rootViewController = initialNavigationController
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - Helpers

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
}
