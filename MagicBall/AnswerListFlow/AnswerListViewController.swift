//
//  AnswersListViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit

private extension AnswerListViewController {

    enum Defaults {
        // Cell
        static let cellIdentifier: String = "answerCell"
    }

}

final class AnswerListViewController: BaseViewController<AnswerListViewControllerView> {

    // MARK: - Private properties

    private let viewModel: AnswerListViewModel
    private let animator: TextFieldAnimator = AnswerTextFieldAnimator()

    // MARK: - Lifecycle

    init(viewModel: AnswerListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rootView.tableView.reloadData()
        setObservationEnabled(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        setObservationEnabled(false)
    }

    // MARK: - Configure

    private func configure() {
        configureTableView()
        configureNewAnswerTextField()
        configureAddNewAnswerButton()
    }

    private func configureTableView() {
        rootView.tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: Defaults.cellIdentifier)
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }

    private func configureNewAnswerTextField() {
        rootView.newAnswerTextField.delegate = self
    }

    private func configureAddNewAnswerButton() {
        rootView.addNewAnswerButton.addTarget(self, action: #selector(addNewAnswerTapped(_:)), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func addNewAnswerTapped(_ sender: UIButton) {
        guard
            let text = rootView.newAnswerTextField.text,
            !text.isEmpty
            else {
                animator.failedInputAnimation(rootView.newAnswerTextField)
                return
        }

        viewModel.saveDecision(with: text)
        rootView.newAnswerTextField.text = ""
        rootView.newAnswerTextField.resignFirstResponder()
        animator.successInputAnimation(rootView.newAnswerTextField)
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
            rootView.tableView.reloadData()

        case let .update(info):

            rootView.tableView.beginUpdates()

            let deletedIndexPaths = info.deletedIndexes.map({ IndexPath(row: $0, section: 0) })
            rootView.tableView.deleteRows(at: deletedIndexPaths, with: .automatic)

            let insertedIndexPaths = info.insertedIndexes.map({ IndexPath(row: $0, section: 0) })
            rootView.tableView.insertRows(at: insertedIndexPaths, with: .automatic)

            let updatedIndexPaths = info.updatedIndexes.map({ IndexPath(row: $0, section: 0) })
            rootView.tableView.reloadRows(at: updatedIndexPaths, with: .automatic)

            rootView.tableView.endUpdates()
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
        rootView.newAnswerTextField.resignFirstResponder()

        return true
    }

}
