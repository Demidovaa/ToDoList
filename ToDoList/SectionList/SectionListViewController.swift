//
//  SectionListViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import UIKit

class SectionListViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addSectionButton: UIButton!
    
    //MARK: - Properties
    
    private var section: [Section]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var databaseService = DatabaseService()
    
    var test: [String] = ["Today", "Important"]
    var viewColor: UIColor = .systemYellow
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCell()
        
        tableView.delegate = self
        tableView.dataSource = self
                
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configereTitle()
    }
    
    private func configereTitle() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func createCell() {
        let nib = UINib(nibName: "SectionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SectionTableViewCell")
    }
    
    //MARK: - IBAction
    
    @IBAction private func tapPlus(_ sender: Any) {
        
    }
}

extension SectionListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "My List" : "Main"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? test.count : test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell", for: indexPath) as? SectionTableViewCell else { return UITableViewCell() }
        cell.confugureCell(title: test[indexPath.row], count: test.count, color: viewColor)
        return cell
    }
}

extension SectionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let taskList = storyboard?.instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController else { return }
        taskList.title = test[indexPath.row]
        taskList.viewColor = viewColor
        navigationController?.pushViewController(taskList, animated: true)
    }
}
