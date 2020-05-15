//
//  BaseViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 25.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

class BaseViewController<T>: UIViewController where T: UIView {

    var rootView: T {
        // swiftlint:disable:next force_cast
        return view as! T
    }

    override func loadView() {
        view = T()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    private func configureNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
    }
}
