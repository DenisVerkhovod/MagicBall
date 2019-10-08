//
//  SettingsViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit
import SnapKit

private extension SettingsViewController {

    enum Defaults {
        // Cell
        static let cellIdentifier: String = "answerCell"

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

        // AddNewAnswer buttom
        static let addNewAnswerButtonCornerRadius: CGFloat = 5.0
        static let addNewAnswerButtonSize: CGFloat = 30.0

        // TableView
        static let tableViewTopOffset: CGFloat = 20.0
    }

}

final class SettingsViewController: BaseViewController {

    // MARK: - Private properties

    private var viewModel: SettingsViewModel

    // MARK: - Lazy properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Defaults.titleLabelFontSize)
        label.textColor = Asset.Colors.biege.color
        label.text = L10n.Settings.title
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)

        return label
    }()

    private lazy var newAnswerTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: Defaults.newAnswerTextFieldFontSize)
        textField.minimumFontSize = Defaults.newAnswerTextFieldMinimiumFontSize
        textField.adjustsFontSizeToFitWidth = true
        textField.borderStyle = .roundedRect
        textField.placeholder = L10n.Settings.textFieldPlaceholderText
        textField.backgroundColor = Asset.Colors.biege.color

        return textField
    }()

    private lazy var addNewAnswerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.Colors.biege.color
        let titleColor = Asset.Colors.tintBlue.color
        button.setTitleColor(titleColor, for: .normal)
        let title = L10n.Settings.addButtonTitle
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = Defaults.addNewAnswerButtonCornerRadius
        button.addTarget(self, action: #selector(addNewAnswerTapped(_:)), for: .touchUpInside)

        return button
    }()

    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Defaults.inputStackViewSpacing
        stackView.addArrangedSubview(newAnswerTextField)
        stackView.addArrangedSubview(addNewAnswerButton)
        view.addSubview(stackView)

        return stackView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Defaults.cellIdentifier)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        return tableView
    }()

    private lazy var doneBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped(_:)))
        barButton.tintColor = Asset.Colors.tintBlue.color

        return barButton
    }()

    // MARK: - Inititalization

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupViews()
        updateDataSource()
    }

    // MARK: - Configure

    private func configure() {
        configureView()
        configureTableView()
        configureNavigationItem()
    }

    private func configureView() {
        view.backgroundColor = Asset.Colors.mainBlue.color
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    private func configureNewAnswerTextField() {
        newAnswerTextField.delegate = self
    }

    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = doneBarButton
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Defaults.titleLabelTopOffset)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Actions

    @objc private func addNewAnswerTapped(_ sender: UIButton) {
        guard
            let text = newAnswerTextField.text,
            !text.isEmpty
            else { return }

        viewModel.saveDecision(with: text)
        tableView.reloadData()
        newAnswerTextField.text = ""
        newAnswerTextField.resignFirstResponder()
    }

    @objc private func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Helpers

    private func updateDataSource() {
        viewModel.fetchDecisions()
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDecisions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellIdentifier) else {
            fatalError("Failed to dequeue cell with identifier: \(Defaults.cellIdentifier)")
        }
        cell.backgroundColor = Asset.Colors.darkBlue.color
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = viewModel.decision(at: indexPath.row).answer

        return cell
    }

}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: L10n.Settings.deleteActionTitle
        ) { [weak self] _, _, completion in
            let decision = self?.viewModel.decision(at: indexPath.row)
            decision?.removingHandler?()
            self?.tableView.reloadData()
            completion(true)
        }

        let trailingSwipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        trailingSwipeConfiguration.performsFirstActionWithFullSwipe = true

        return trailingSwipeConfiguration
    }

}

// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newAnswerTextField.resignFirstResponder()

        return true
    }

}
