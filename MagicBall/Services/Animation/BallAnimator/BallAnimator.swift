//
//  BallAnimator.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 22.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

protocol BallAnimator {

    /**
     Performs pulsation for given view.

     - Parameter view: UIView to animate.
     */
    func startPulsation(for view: UIView)

    /**
     Stops pulsation for given view.

     - Parameter view: UIView to stop it's pulsation.
     - Parameter completion: Will be called when pulsation stops.
     */
    func stopPulsation(for view: UIView, completion: @escaping () -> Void)

    /**
     Animates presenting view with given text.

     - Parameter view: View to present.
     - Parameter text: Text to assign to view.
     */
    func answerPresentingAnimation(in view: UITextView, with text: String)

}

final class MagicBallAnimator: BallAnimator {

    // MARK: - Public properties

    var shouldPulsate: Bool = false

    // MARK: - Private properties

    private var pulsationOnCompleted: (() -> Void)?

    // MARK: - Pulsation

    func startPulsation(for view: UIView) {
        shouldPulsate = true
        pulsate(view)
    }

    func stopPulsation(for view: UIView, completion: @escaping () -> Void) {
        shouldPulsate = false
        pulsationOnCompleted = completion
    }

    private func pulsate(_ view: UIView) {
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.21, relativeDuration: 0.2) {
                view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.41, relativeDuration: 0.2) {
                view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.61, relativeDuration: 0.2) {
                view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.81, relativeDuration: 0.2) {
                view.transform = .identity
            }
        }, completion: { [weak self] _ in
            if self?.shouldPulsate == true {
                self?.pulsate(view)
            } else {
                self?.pulsationOnCompleted?()
            }
        })
    }

    // MARK: - Answer presenting

    func answerPresentingAnimation(in view: UITextView, with text: String) {
        let direction = Direction.allCases.randomElement() ?? .fromLeft
        var initialTransform: CATransform3D

        switch direction {
        case .fromLeft:
            initialTransform = CATransform3DMakeRotation(-.pi / 2, 1.0, 2.0, 1.0)

        case .fromRight:
            initialTransform = CATransform3DMakeRotation(.pi / 2, 1.0, -2.0, 1.0)
        }

        let transformAnimation = CASpringAnimation(keyPath: "transform")
        transformAnimation.fromValue = initialTransform
        transformAnimation.toValue = CATransform3DIdentity
        transformAnimation.duration = transformAnimation.settlingDuration
        view.layer.add(transformAnimation, forKey: transformAnimation.keyPath)

        view.text = text
    }
}

private extension MagicBallAnimator {

    enum Direction: CaseIterable {
        case fromLeft
        case fromRight
    }

}
