//
//  MagicBallAnimator.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 20.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

protocol MagicBallAnimator {

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
     Animates presenting label with given text.
     
     - Parameter label: Label to present.
     - Parameter text: Text to assign to label.
     */
    func answerPresentingAnimation(in label: UILabel, with text: String)

    /**
     Animates dismissing label.
     
     - Parameter label: Label to dismiss.
     */
    func answerDismissingAnimation(in label: UILabel)

    /**
     Performs animation which indicates failed input for given text field.
     
     - Parameter textField: Text field to aplly animation.
     */
    func failedInputAnimation(_ textField: UITextField)

    /**
     Performs animation which indicates success input for given text field.
     
     - Parameter textField: Text field to aplly animation.
     */
    func successInputAnimation(_ textField: UITextField)

}

final class Animator: MagicBallAnimator {

    // MARK: - Public properties

    var shouldPulsation: Bool = false

    // MARK: - Private properties

    private var pulsationOnCompleted: (() -> Void)?

    // MARK: - Pulsation

    func startPulsation(for view: UIView) {
        shouldPulsation = true
        pulse(view)
    }

    func stopPulsation(for view: UIView, completion: @escaping () -> Void) {
        shouldPulsation = false
        pulsationOnCompleted = completion
    }

    private func pulse(_ view: UIView) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.26, relativeDuration: 0.5) {
                view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.76, relativeDuration: 0.25) {
                view.transform = .identity
            }
        }, completion: { [weak self] _ in
            if self?.shouldPulsation == true {
                self?.pulse(view)
            } else {
                self?.pulsationOnCompleted?()
            }
        })
    }

    // MARK: - Answer presenting

    func answerPresentingAnimation(in label: UILabel, with text: String) {
        label.text = text
        UIView.animate(withDuration: 0.3) {
            label.alpha = 1.0
        }
    }

    func answerDismissingAnimation(in label: UILabel) {
        UIView.animate(withDuration: 0.3) {
            label.alpha = 0.0
        }
    }

    // MARK: - TextField animation

    func failedInputAnimation(_ textField: UITextField) {
        let redColor = Asset.Colors.borderRed.color
        let flash = makeFlashBorderAnimation(with: redColor, duration: 0.2, repeatCount: 3)

        textField.layer.add(flash, forKey: Constants.Animation.failedInput)
    }

    func successInputAnimation(_ textField: UITextField) {
        let greenColor = Asset.Colors.borderGreen.color
        let flash = makeFlashBorderAnimation(with: greenColor, duration: 0.2, repeatCount: 3)

        textField.layer.add(flash, forKey: Constants.Animation.successInput)
    }

    private func makeFlashBorderAnimation(
        with color: UIColor,
        duration: CFTimeInterval,
        repeatCount: Float
    ) -> CABasicAnimation {

        let flashBorder = CABasicAnimation(keyPath: Constants.Animation.borderColor)
        flashBorder.fromValue = color.cgColor
        flashBorder.toValue = Asset.Colors.borderWhite.color.cgColor
        flashBorder.duration = duration
        flashBorder.repeatCount = repeatCount

        return flashBorder
    }
}
