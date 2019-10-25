//
//  AnswerListViewControllerView.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 25.10.2019.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit
import SnapKit

private extension AnswerListViewControllerView {

    enum Defaults {

        // Title label
        static let titleLabelFontSize: CGFloat = 25.0
        static let titleLabelTopOffset: CGFloat = 10.0
        static let titleLabelLeadingTrailingOffset: CGFloat = 20.0

        // Input stack view
        static let inputStackViewSpacing: CGFloat = 10.0
        static let inputStackViewTopOffset: CGFloat = 20.0

        // NewAnswerTextField
        static let newAnswerTextFieldFontSize: CGFloat = 17.0
        static let newAnswerTextFieldMinimiumFontSize: CGFloat = 12.0
        static let newAnswerTextFieldBorderWidth: CGFloat = 2.0
        static let newAnswerTextFieldCornerRadius: CGFloat = 5.0

        // AddNewAnswer buttom
        static let addNewAnswerButtonCornerRadius: CGFloat = 5.0
        static let addNewAnswerButtonSize: CGFloat = 30.0

        // TableView
        static let tableViewTopOffset: CGFloat = 20.0
        static let tableViewEstimatedRowHeight: CGFloat = 44.0
    }

}

final class AnswerListViewControllerView: UIView {

    // MARK: - Lazy properties

    lazy var newAnswerTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: Defaults.newAnswerTextFieldFontSize)
        textField.minimumFontSize = Defaults.newAnswerTextFieldMinimiumFontSize
        textField.adjustsFontSizeToFitWidth = true
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = Defaults.newAnswerTextFieldBorderWidth
        textField.layer.borderColor = Asset.Colors.borderWhite.color.cgColor
        textField.layer.cornerRadius = Defaults.newAnswerTextFieldCornerRadius
        textField.placeholder = L10n.AnswerList.textFieldPlaceholderText
        textField.backgroundColor = Asset.Colors.biege.color

        return textField
    }()

    lazy var addNewAnswerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.Colors.biege.color
        let titleColor = Asset.Colors.tintBlue.color
        button.setTitleColor(titleColor, for: .normal)
        let title = L10n.AnswerList.addButtonTitle
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = Defaults.addNewAnswerButtonCornerRadius

        return button
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Defaults.tableViewEstimatedRowHeight
        tableView.tableFooterView = UIView()
        addSubview(tableView)

        return tableView
    }()

    private lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.font = .boldSystemFont(ofSize: Defaults.titleLabelFontSize)
         label.textColor = Asset.Colors.biege.color
         label.text = L10n.AnswerList.title
         label.minimumScaleFactor = 0.5
         label.textAlignment = .center
         label.numberOfLines = 0
         addSubview(label)

         return label
     }()

    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Defaults.inputStackViewSpacing
        stackView.addArrangedSubview(newAnswerTextField)
        stackView.addArrangedSubview(addNewAnswerButton)
        addSubview(stackView)

        return stackView
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
        setupInputStackView()
        setupAddNewAnswerButton()
        setupTableView()
    }

    private func setupTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Defaults.titleLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(Defaults.titleLabelLeadingTrailingOffset)
        }
    }

    private func setupInputStackView() {
        inputStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Defaults.inputStackViewTopOffset)
            make.trailing.leading.equalTo(titleLabel)
        }
    }

    private func setupAddNewAnswerButton() {
        addNewAnswerButton.snp.makeConstraints { make in
            make.size.greaterThanOrEqualTo(Defaults.addNewAnswerButtonSize)
            make.width.equalTo(addNewAnswerButton.snp.height).multipliedBy(1)
        }
    }

    private func setupTableView() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(inputStackView.snp.bottom).offset(Defaults.tableViewTopOffset)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
