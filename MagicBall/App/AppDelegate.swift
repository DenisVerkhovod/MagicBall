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
    var coordinator: FlowCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let answerStorage = makeCoreDataManager()
        let initialConfigurator: InitialConfigurator = InitialConfigurationManager(answerStorage: answerStorage)
        initialConfigurator.presetAnswers()

        window = UIWindow(frame: UIScreen.main.bounds)

        let appCoordinator = AppCoordinator(
            parent: nil,
            networkManager: NetworkManager(),
            onDeviceMagicBall: OnDeviceMagicBall(answerStorage: answerStorage),
            shakeCounter: MagicBallShakeCounter(),
            decisionStorage: answerStorage
        )

        coordinator = appCoordinator
        let controller = appCoordinator.createFlow()
        appCoordinator.containerViewController = controller

        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - Helpers

    private func makeCoreDataManager() -> CoreDataManager {
        let coreDataStack = CoreDataStack(modelName: Constants.CoreData.modelName)

        return CoreDataManager(coreDataStack: coreDataStack)
    }
}
