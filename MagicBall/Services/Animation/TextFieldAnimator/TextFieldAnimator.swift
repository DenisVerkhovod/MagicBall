//
//  TextFieldAnimator.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 22.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

protocol TextFieldAnimator {

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

final class AnswerTextFieldAnimator: TextFieldAnimator {

    // MARK: - TextField animation

    func failedInputAnimation(_ textField: UITextField) {
        let redColor = Asset.Colors.borderRed.color
        let flash = makeFlashBorderAnimation(with: redColor, duration: 0.2, repeatCount: 3)

        textField.layer.add(flash, forKey: flash.keyPath)
    }

    func successInputAnimation(_ textField: UITextField) {
        let greenColor = Asset.Colors.borderGreen.color
        let flash = makeFlashBorderAnimation(with: greenColor, duration: 0.2, repeatCount: 3)

        textField.layer.add(flash, forKey: flash.keyPath)
    }

    private func makeFlashBorderAnimation(
        with color: UIColor,
        duration: CFTimeInterval,
        repeatCount: Float
    ) -> CABasicAnimation {

        let flashBorder = CABasicAnimation(keyPath: "borderColor")
        flashBorder.fromValue = color.cgColor
        flashBorder.toValue = Asset.Colors.borderWhite.color.cgColor
        flashBorder.duration = duration
        flashBorder.repeatCount = repeatCount

        return flashBorder
    }

}
