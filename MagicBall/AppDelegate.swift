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

        return true
    }

}
