//
//  AnswersListViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit
import SnapKit

private extension AnswerListViewController {

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
        static let newAnswerTextFieldBorderWidth: CGFloat = 2.0
        static let newAnswerTextFieldCornerRadius: CGFloat = 5.0

        // AddNewAnswer buttom
        static let addNewAnswerButtonCornerRadius: CGFloat = 5.0
        static let addNewAnswerButtonSize: CGFloat = 30.0

        // TableView
        static let tableViewTopOffset: CGFloat = 20.0
    }

}

final class AnswerListViewController: UIViewController {

    // MARK: - Private properties

    private let viewModel: AnswerListViewModel
    private let animator: MagicBallAnimator

    // MARK: - Lazy properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Defaults.titleLabelFontSize)
        label.textColor = Asset.Colors.biege.color
        label.text = L10n.AnswerList.title
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
        textField.layer.borderWidth = Defaults.newAnswerTextFieldBorderWidth
        textField.layer.borderColor = Asset.Colors.borderWhite.color.cgColor
        textField.layer.cornerRadius = Defaults.newAnswerTextFieldCornerRadius
        textField.placeholder = L10n.AnswerList.textFieldPlaceholderText
        textField.backgroundColor = Asset.Colors.biege.color

        return textField
    }()

    private lazy var addNewAnswerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.Colors.biege.color
        let titleColor = Asset.Colors.tintBlue.color
        button.setTitleColor(titleColor, for: .normal)
        let title = L10n.AnswerList.addButtonTitle
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
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: Defaults.cellIdentifier)
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        return tableView
    }()

    // MARK: - Inititalization

    init(viewModel: AnswerListViewModel, animator: MagicBallAnimator) {
        self.viewModel = viewModel
        self.animator = animator

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        setObservationEnabled(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        setObservationEnabled(false)
    }

    // MARK: - Configure

    private func configure() {
        configureView()
        configureTableView()
        configureNewAnswerTextField()
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
            else {
                animator.failedInputAnimation(newAnswerTextField)
                return
        }

        viewModel.saveDecision(with: text)
        newAnswerTextField.text = ""
        newAnswerTextField.resignFirstResponder()
        animator.successInputAnimation(newAnswerTextField)
    }

    // MARK: - Observation

    private func setObservationEnabled(_ enabled: Bool) {
        if enabled {
            viewModel.decisionsDidChange = { [weak self] changes in
                self?.updateTableView(with: changes)
            }
        } else {
            viewModel.decisionsDidChange = nil
        }
    }

    private func updateTableView(with changes: TableViewChanges) {

        switch changes {
        case .initial:
            tableView.reloadData()

        case let .update(info):

            tableView.beginUpdates()

            let deletedIndexPaths = info.deletedIndexes.map({ IndexPath(row: $0, section: 0) })
            tableView.deleteRows(at: deletedIndexPaths, with: .automatic)

            let insertedIndexPaths = info.insertedIndexes.map({ IndexPath(row: $0, section: 0) })
            tableView.insertRows(at: insertedIndexPaths, with: .automatic)

            let updatedIndexPaths = info.updatedIndexes.map({ IndexPath(row: $0, section: 0) })
            tableView.reloadRows(at: updatedIndexPaths, with: .automatic)

            tableView.endUpdates()
        }
    }
}

// MARK: - UITableViewDataSource

extension AnswerListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDecisions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellIdentifier) as? AnswerTableViewCell
            else {
                fatalError("Failed to dequeue cell with identifier: \(Defaults.cellIdentifier)")
        }

        let decision = viewModel.decision(at: indexPath.row)
        cell.answerLabel.text = decision.answer
        cell.dateLabel.text = decision.createdAt

        return cell
    }

}

// MARK: - UITableViewDelegate

extension AnswerListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: L10n.AnswerList.deleteActionTitle
        ) { [weak self] _, _, completion in
            let decision = self?.viewModel.decision(at: indexPath.row)
            decision?.removingHandler?()

            completion(true)
        }

        let trailingSwipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        trailingSwipeConfiguration.performsFirstActionWithFullSwipe = true

        return trailingSwipeConfiguration
    }

}

// MARK: - UITextFieldDelegate

extension AnswerListViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newAnswerTextField.resignFirstResponder()

        return true
    }

}
