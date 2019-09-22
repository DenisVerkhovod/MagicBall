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
    
    @IBOutlet private weak var newAnswerTextField: UITextField!
    @IBOutlet private weak var addNewAnswerButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private properties
    
    private let localStorageManager: LocalStorageProtocol = LocalStorageManager()
    private var answers: [String] = []
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        prepareDataSource()
    }
    
    // MARK: - Configure
    
    private func configure() {
        configureTableView()
        configureNewAnswerTextField()
        configureAddNewAnswerButton()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    private func configureNewAnswerTextField() {
        newAnswerTextField.delegate = self
    }
    
    private func configureAddNewAnswerButton() {
        addNewAnswerButton.layer.cornerRadius = Defaults.addNewAnswerButtonCornerRadius
    }
    
    // MARK: - Actions
    
    @IBAction func addNewAnswerTapped(_ sender: UIButton) {
        guard
            let text = newAnswerTextField.text,
            !text.isEmpty
            else { return }
        localStorageManager.addAnswer(text)
        prepareDataSource()
        tableView.reloadData()
        newAnswerTextField.text = ""
        newAnswerTextField.resignFirstResponder()
    }
    
    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func prepareDataSource() {
        answers = localStorageManager.answers
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Defaults.cellIdentifier) else {
            fatalError("Failed to dequeue cell with identifier: \(Defaults.cellIdentifier)")
        }
        cell.textLabel?.text = answers[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let strongSelf = self else {
                completion(false)
                
                return
            }
            let answerToRemove = strongSelf.answers[indexPath.row]
            strongSelf.localStorageManager.removeAnswer(answerToRemove)
            completion(true)
        }
        
        let trailingSwipeConfiguration: UISwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
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
