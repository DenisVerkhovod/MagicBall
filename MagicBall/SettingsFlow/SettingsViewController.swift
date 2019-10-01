//
//  SettingsViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

private extension SettingsViewController {

    enum Defaults {
        // Cell
        static let cellIdentifier: String = "answerCell"
        // AddNewAnswer buttom
        static let addNewAnswerButtonCornerRadius: CGFloat = 5.0
    }

}

final class SettingsViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private weak var doneBarButton: UIBarButtonItem!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var newAnswerTextField: UITextField!
    @IBOutlet private weak var addNewAnswerButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private properties

    private var viewModel: SettingsViewModel!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        updateDataSource()
    }

    // MARK: - Dependency injection

    func setViewModel(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Configure

    private func configure() {
        configureView()
        configureDoneBarButton()
        configureTitleLabel()
        configureTableView()
        configureNewAnswerTextField()
        configureAddNewAnswerButton()
    }

    private func configureView() {
        view.backgroundColor = Asset.Colors.mainBlue.color
    }

    private func configureDoneBarButton() {
        doneBarButton.tintColor = Asset.Colors.tintBlue.color
    }

    private func configureTitleLabel() {
        titleLabel.text = L10n.Settings.title
        titleLabel.textColor = Asset.Colors.biege.color
    }

    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }

    private func configureNewAnswerTextField() {
        newAnswerTextField.placeholder = L10n.Settings.textFieldPlaceholderText
        newAnswerTextField.delegate = self
    }

    private func configureAddNewAnswerButton() {
        addNewAnswerButton.layer.cornerRadius = Defaults.addNewAnswerButtonCornerRadius
    }

    // MARK: - Actions

    @IBAction private func addNewAnswerTapped(_ sender: UIButton) {
        guard
            let text = newAnswerTextField.text,
            !text.isEmpty
            else { return }

        viewModel.saveDecision(with: text)
        tableView.reloadData()
        newAnswerTextField.text = ""
        newAnswerTextField.resignFirstResponder()
    }

    @IBAction private func doneTapped(_ sender: UIBarButtonItem) {
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
