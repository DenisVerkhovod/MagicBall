//
//  TriangleTextField.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 22.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

final class TriangleTextView: UITextView {

    // MARK: - Public properties

    var preferredFontSize: CGFloat?
    var minimumFontSize: CGFloat?

    // MARK: - Private properties

    private var mainColor = UIColor.white
    private var secondaryColor = UIColor.black

    // MARK: - Lazy properties

    private lazy var triangleShape: CAShapeLayer = {
        let shape = CAShapeLayer()

        return shape
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .radial
        gradient.colors = [mainColor.cgColor, secondaryColor.cgColor ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.1, y: 1.1)
        gradient.mask = triangleShape
        layer.insertSublayer(gradient, at: 0)

        return gradient
    }()

    // MARK: - Initialization

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        triangleShape.path = trianglePath().cgPath
        gradientLayer.frame = bounds
        adjustFontSizeToFit()

        textContainer.exclusionPaths = [exclusionPath()]
    }

    // MARK: - Public methods

    func setMainColor(_ color: UIColor) {
        mainColor = color
    }
    func setSecondaryColor(_ color: UIColor) {
        secondaryColor = color
    }

    // MARK: - Configure

    private func configure() {
        isEditable = false
        isSelectable = false
        textAlignment = .center
        backgroundColor = .clear
    }

    // MARK: - Helpers

    private func trianglePath() -> UIBezierPath {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        path.close()

        return path
    }

    private func exclusionPath() -> UIBezierPath {
        let path = UIBezierPath()

        path.move(to: bounds.origin)
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxY, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
        path.close()

        return path
    }

    /// Scales font size to fit text into top half of bounds.
    private func adjustFontSizeToFit() {
        guard
            let minimumFontSize = minimumFontSize,
            let preferredFontSize = preferredFontSize
            else { return }
        font = font?.withSize(preferredFontSize)

        while
            sizeThatFits(CGSize(width: bounds.width,
                                height: .greatestFiniteMagnitude)).height >= bounds.size.height / 2 {
                guard
                    let fontSize = font?.pointSize,
                    fontSize >= minimumFontSize
                    else { break }

                let newFontSize = fontSize - 0.5
                font = font?.withSize(newFontSize)
        }
    }
}
