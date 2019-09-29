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
        window?.backgroundColor = .white
        
        let mainViewController = prepareMainViewController()
        let initialNavigationController = UINavigationController(rootViewController: mainViewController)
        
        window?.rootViewController = initialNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - Helpers
    
    private func prepareMainViewController() -> MainViewController {
        let mainViewController = StoryboardScene.Main.mainViewController.instantiate()
        let mainViewModel = prepareMainViewModel()
        mainViewController.setViewModel(mainViewModel)
        
        return mainViewController
    }
    
    private func prepareMainModel() -> MainModel {
        let networkManager = NetworkManager()
        let onDeviceMagicBall = OnDeviceMagicBall()
        let mainModel = MainModel(networkManager: networkManager, onDeviceMagicBall: onDeviceMagicBall)
        
        return mainModel
    }
    
    private func prepareMainViewModel() -> MainViewModel {
        let mainModel = prepareMainModel()
        let mainViewModel = MainViewModel(model: mainModel)
        
        return mainViewModel
    }
}
