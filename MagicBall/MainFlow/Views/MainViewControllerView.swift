//
//  MainViewControllerView.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 25.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit
import SnapKit

private extension MainViewControllerView {

    enum Defaults {
        // Title label
        static let titleLabelFontSize: CGFloat = 36.0
        static let titleLabelTopOffset: CGFloat = 10.0
        static let titleLabelLeadingTrailingOffset: CGFloat = 20.0

        // Total shakes label
        static let totalShakesLabelFontSize: CGFloat = 17.0
        static let totalShakesLabelTopOffset: CGFloat = 10.0

        // Ball container
        static let ballContainerTopOffset: CGFloat = 10.0

        // Ball background view
        static let ballBackgroundSizeDivider: CGFloat = 2.0
        static let ballBackgroundViewZPosition: CGFloat = -1000.0

        // Ball image view
        static let ballImageViewZPosition: CGFloat = 1000.0

        // Answer text view
        static let answerTextViewPreferredFontSize: CGFloat = 21.0
        static let answerTextViewMinimumFontSize: CGFloat = 12.0
        static let answerTextViewHeightMultiplier: CGFloat = 0.35
    }

}

final class MainViewControllerView: UIView {

   // MARK: - Lazy properties

     private lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.font = .boldSystemFont(ofSize: Defaults.titleLabelFontSize)
         label.textColor = Asset.Colors.biege.color
         label.text = L10n.Main.title
         label.adjustsFontSizeToFitWidth = true
         label.minimumScaleFactor = 0.5
         label.textAlignment = .center
         label.numberOfLines = 0
         addSubview(label)

         return label
     }()

    lazy var totalShakesLabel: UILabel = {
         let label = UILabel()
         label.font = .systemFont(ofSize: Defaults.totalShakesLabelFontSize)
         label.textColor = Asset.Colors.biege.color
         label.text = L10n.Main.totalShakes
         addSubview(label)

         return label
     }()

    lazy var ballContainer: UIView = {
         let container = UIView()
         container.backgroundColor = .clear
         addSubview(container)

         return container
     }()

     private lazy var ballBackgroundView: UIView = {
         let backgroundView = UIView()
         backgroundView.backgroundColor = Asset.Colors.black.color
         backgroundView.layer.zPosition = Defaults.ballBackgroundViewZPosition
         ballContainer.insertSubview(backgroundView, at: 0)

         return backgroundView
     }()

    lazy var answerTextView: TriangleTextView = {
         let answerView = TriangleTextView()
         answerView.minimumFontSize = Defaults.answerTextViewMinimumFontSize
         answerView.preferredFontSize = Defaults.answerTextViewPreferredFontSize
         answerView.setMainColor(Asset.Colors.gradientBlue.color)
         answerView.textColor = Asset.Colors.turquoise.color
         answerView.text = L10n.Main.answerLabelDefaultText
         ballContainer.insertSubview(answerView, aboveSubview: ballBackgroundView)

         return answerView
     }()

     private lazy var ballImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.image = Asset.Images.ball.image
         imageView.contentMode = .scaleAspectFit
         imageView.layer.zPosition = Defaults.ballImageViewZPosition
         ballContainer.insertSubview(imageView, aboveSubview: answerTextView)

         return imageView
     }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    private func configure() {
        backgroundColor = Asset.Colors.mainBlue.color
    }

    // MARK: - Setup views

    private func setupViews() {
        setupTitleLabel()
        setupTotalShakesLabel()
        setupBallContainer()
        setupBallBackgroundView()
        setupBallImageView()
        setupAnswerTextView()
    }

    private func setupTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Defaults.titleLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(Defaults.titleLabelLeadingTrailingOffset)
        }
    }

    private func setupTotalShakesLabel() {
        totalShakesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Defaults.totalShakesLabelTopOffset)
        }
    }

    private func setupBallContainer() {
        ballContainer.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(totalShakesLabel.snp.bottom).offset(Defaults.ballContainerTopOffset)
            make.leading.trailing.equalTo(titleLabel)
            make.centerY.equalToSuperview().priority(.medium)
            make.width.equalTo(ballImageView.snp.height).multipliedBy(1)
        }
    }

    private func setupBallBackgroundView() {
        ballBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().dividedBy(Defaults.ballBackgroundSizeDivider)
        }
    }

    private func setupBallImageView() {
        ballImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupAnswerTextView() {
        answerTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(answerTextView.snp.height)
            make.height.equalToSuperview().multipliedBy(Defaults.answerTextViewHeightMultiplier)
        }
    }
}
