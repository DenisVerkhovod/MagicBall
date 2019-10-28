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
import RxDataSources

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
    private let removeDecision: PublishRelay<Int>
    private let disposeBag = DisposeBag()

    // MARK: - Lazy properties

    private lazy var dataSource: RxTableViewSectionedAnimatedDataSource<DecisionsSection> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<DecisionsSection>(
            configureCell: { (_, tableView, indexPath, presentableDecision) -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: Defaults.cellIdentifier,
                    for: indexPath
                    ) as? AnswerTableViewCell
                    else {
                        fatalError("Failed to dequeue cell with identifier: \(Defaults.cellIdentifier)")
                }

                cell.answerLabel.text = presentableDecision.answer
                cell.dateLabel.text = presentableDecision.createdAt

                return cell
        })

        dataSource.canEditRowAtIndexPath = { _, _ in
            return true
        }
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].header
        }

        return dataSource
    }()

    // MARK: - Lifecycle

    init(viewModel: AnswerListViewModel) {
        self.viewModel = viewModel
        self.removeDecision = PublishRelay()

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

    // MARK: - Configure

    private func configure() {
        configureTableView()
        configureNewAnswerTextField()
    }

    private func configureTableView() {
        rootView.tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: Defaults.cellIdentifier)
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

        rootView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        viewModel
            .decisionsSections
            .bind(to: rootView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        removeDecision
            .bind(to: viewModel.removeDecision)
            .disposed(by: disposeBag)
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
            self?.removeDecision.accept(indexPath.row)

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
