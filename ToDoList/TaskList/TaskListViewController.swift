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
    
    private var countCell = 0
    private var textTask: [String] = []
    
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
    
    //MARK: - IBAction
    
    @IBAction private func tapPlus(_ sender: Any) {
        guard let popup = storyboard?.instantiateViewController(withIdentifier: "TaskPopupViewController") as? TaskPopupViewController else { return }
        
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .coverVertical
        
        popup.closePopup = { [weak self] text in
            guard let self = self else { return }
            if !text.isEmpty {
                self.countCell += 1
                self.textTask.append(text)
                self.tableView.insertRows(at: [IndexPath(row: self.countCell - 1, section: 0)], with: .automatic)
            }
            self.dismiss(animated: true)
            UIView.animate(withDuration: 0.3) {
                self.view.alpha = 1.0
            }
        }
        
        view.alpha = 0.4
        present(popup, animated: true, completion: nil)
    }
}

//MARK: - Extension

extension TaskListViewController: UITableViewDelegate {
    
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.configureCell(text: textTask[indexPath.row])
        return cell
    }
}
