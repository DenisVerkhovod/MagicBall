//
//  AnswersListViewController.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    private let disposeBag = DisposeBag()

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
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rootView.tableView.reloadData()
    }

    // MARK: - Configure

    private func configure() {
        configureTableView()
        configureNewAnswerTextField()
    }

    private func configureTableView() {
        rootView.tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: Defaults.cellIdentifier)
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }

    private func configureNewAnswerTextField() {
        rootView.newAnswerTextField.delegate = self
    }

    private func setupBindings() {
        rootView.addNewAnswerButton.rx.tap
            .withLatestFrom(rootView.newAnswerTextField.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                self?.handleTextFieldInput(text)
            })
            .disposed(by: disposeBag)

        viewModel
            .decisionsChanges
            .subscribe(onNext: { [weak self] changes in
                self?.updateTableView(with: changes)
            })
            .disposed(by: disposeBag
        )
    }

    // MARK: - Helpers

    private func handleTextFieldInput(_ text: String) {
        guard !text.isEmpty else {
            animator.failedInputAnimation(rootView.newAnswerTextField)
            return
        }

        viewModel.newAnswer.onNext(text)
        rootView.newAnswerTextField.text = ""
        rootView.newAnswerTextField.resignFirstResponder()
        animator.successInputAnimation(rootView.newAnswerTextField)
    }

    private func updateTableView(with changes: TableViewChanges) {
        guard rootView.tableView.window != nil else { return }

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

        case .none:
            break
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
