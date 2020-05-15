//
//  FlowCoordinator.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 28.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

protocol FlowCoordinator: class {

    var containerViewController: UIViewController? { get set }

    @discardableResult
    func createFlow() -> UIViewController
}
