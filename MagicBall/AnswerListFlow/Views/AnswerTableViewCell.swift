//
//  AnswerTableViewCell.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 16.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

private extension AnswerTableViewCell {

    enum Defaults {
        // Answer label
        static let answerLabelFontSize: CGFloat = 17
        static let answerLabelEdgeOffset: CGFloat = 10.0

        // Date label
        static let dateLabelFontSize: CGFloat = 14
        static let dateLabelLeadingTrailingOffset: CGFloat = 10.0
    }
}

final class AnswerTableViewCell: UITableViewCell {

    // MARK: - Lazy properties

    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Defaults.answerLabelFontSize)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        addSubview(label)

        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Defaults.dateLabelFontSize)
        label.textColor = Asset.Colors.subtitleGray.color
        addSubview(label)

        return label
    }()

    // MARK: - Inititalization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configure()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    private func configure() {
        configureView()
    }

    private func configureView() {
        backgroundColor = Asset.Colors.darkBlue.color
    }

    // MARK: - Setup views

    private func setupViews() {
        setupAnswerLabel()
        setupDateLabel()
    }

    private func setupAnswerLabel() {
        answerLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(Defaults.answerLabelEdgeOffset)
        }
    }

    private func setupDateLabel() {
        dateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(answerLabel.snp.trailing).offset(Defaults.dateLabelLeadingTrailingOffset)
            make.trailing.equalToSuperview().inset(Defaults.dateLabelLeadingTrailingOffset)
            make.centerY.equalToSuperview()
        }
    }
}
