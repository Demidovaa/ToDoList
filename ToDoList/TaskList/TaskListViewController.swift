//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 17.03.2021.
//

import UIKit

class TaskListViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var addButtonView: UIView!
    
    //MARK: - Properties
    
    private var textTask: [String] = []
    private var currentEditTaskIndex: IndexPath?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        createCell()
        configereTitle(text: "Today")
        configureAddButton(backColor: .systemTeal, tintColor: .white)
    }
    
    //MARK: - Private Func
    
    private func configereTitle(text: String) {
        self.title = text
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func configureAddButton(backColor: UIColor = .gray, tintColor: UIColor = .black) {
        addButtonView.roundCorners(type: .all, radius: 30)
        addButtonView.backgroundColor = backColor
        
        addButton.tintColor = tintColor
    }
    
    private func createCell() {
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TaskTableViewCell")
    }
    
    private func presentingPopupFor(indexPath: IndexPath?) {
        guard let popup = storyboard?.instantiateViewController(withIdentifier: "TaskPopupViewController") as? TaskPopupViewController else { return }
        popup.delegateHandle = self
        
        if let index = indexPath?.row {
            popup.task = textTask[index]
        }
        
        view.alpha = 0.4
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .coverVertical
        present(popup, animated: true, completion: nil)
    }
    
    //MARK: - IBAction
    
    @IBAction private func tapPlus(_ sender: Any) {
        presentingPopupFor(indexPath: nil)
    }
}

//MARK: - Extension

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.configureCell(text: textTask[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentEditTaskIndex = indexPath
        presentingPopupFor(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var actions = [UIContextualAction]()
        
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            guard let self = self else { return }
            self.textTask.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            
            completion(true)
        }
        
        let configureImage = UIImage.SymbolConfiguration(pointSize: 12.0, weight: .bold, scale: .large)
        
        delete.image = UIImage(systemName: "trash",
                               withConfiguration: configureImage)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        delete.backgroundColor = .systemBackground // Update color
        
        actions.append(delete)
        
        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}

extension TaskListViewController: DelegateTaskHandler {
    func create(result: ResultTask) {
        switch result {
        case .success(let text):
            textTask.append(text)
            tableView.insertRows(at: [IndexPath(row: self.textTask.count - 1, section: 0)],
                                      with: .automatic)
        case .failure:
            break
        }
    }
    
    func update(result: ResultTask) {
        guard let currentEditTaskIndex = currentEditTaskIndex else { return }
        switch result {
        case .success(let text):
            textTask[currentEditTaskIndex.row] = text
            tableView.reloadRows(at: [currentEditTaskIndex], with: .automatic)
        case .failure:
            textTask.remove(at: currentEditTaskIndex.row)
            tableView.deleteRows(at: [currentEditTaskIndex], with: .left)
        }
    }
    
    func closePopup() {
        self.dismiss(animated: true)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
}
