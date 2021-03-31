//
//  SectionListViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import UIKit

class SectionListViewController: UIViewController {
    
    var model: SectionListModeling!
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addSectionButton: UIButton!
    
    //MARK: - Properties
        
    //var viewColor: UIColor = .systemYellow
    
    //MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        model = SectionListModel(localStore: DatabaseService())
        model.delegateUpdate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        model.fetchSectionList()
                
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTitle()
    }
    
    private func configureTitle() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "SectionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SectionTableViewCell")
    }
    
    //MARK: - IBAction
    
    @IBAction private func tapPlus(_ sender: Any) {
        guard let creatingSection = storyboard?.instantiateViewController(withIdentifier: "CreatingSectionViewController") as? CreatingSectionViewController else { return }
        
        creatingSection.completionHandler = { [weak self] section in
            guard let self = self else { return }
            self.model.setSection(section: section)
            self.dismiss(animated: true, completion: nil)
        }
        present(creatingSection, animated: true, completion: nil)
    }
}

extension SectionListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My List"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell", for: indexPath) as? SectionTableViewCell
        else { return .init() }
        
        if let formatData = model.getFormat(at: indexPath.row) {
            cell.confugureCell(title: formatData.name, count: 0, color: formatData.color)
        }
        return cell
    }
}

extension SectionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let taskList = storyboard?.instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController
        else { return }
        guard let formatData = model.getFormat(at: indexPath.row) else { return }
        taskList.title = formatData.name
        taskList.viewColor = formatData.color
        navigationController?.pushViewController(taskList, animated: true)
    }
}

extension SectionListViewController: DelegateUpdateViewSection {
    func updateSection() {
        tableView.reloadData()
    }
}
