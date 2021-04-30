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
    @IBOutlet private weak var addButtonView: UIView!
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let localStore = DatabaseService()
        model = SectionListModel(localStore: localStore)
        model.delegateUpdate = self
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        registerCell()
        configureView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        model.fetchSectionList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationController?.navigationBar.isHidden = true
    }

    private func configureView() {
        addSectionButton.tintColor = .white
        addButtonView.backgroundColor = .systemBlue
        addButtonView.roundCorners(type: .all, radius: AppConstants.buttonRounding)
        addButtonView.layer.masksToBounds = false
        addButtonView.addShadow(color: .black, size: AppConstants.sizeShadow)
    }
    
    private func registerCell() {
        tableView.register(cellType: SectionTableViewCell.self)
    }
    
    private func showAlert(index: Int) {
        guard let name = model.getSection(index: index)?.name else { return }
        let alert = UIAlertController(title: "Delete \(name)", message: "Are you sure you want to delete this section?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .destructive,
                                      handler: { [weak self] _ in
                                        guard let self = self else { return }
                                        self.model.deleteSection(index: index)
                                      }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(with: SectionTableViewCell.self, for: indexPath)
        if let section = model.getSection(index: indexPath.row),
           let countTask = model.getInfoTask(index: indexPath.row) {
            
            cell.confugureCell(title: section.name,
                               count: countTask.all,
                               completedTask: countTask.completed,
                               color: UIColor.getColor(from: section.color) ?? .white)
            
            cell.completedHandler = { [weak self, indexPath] in
                guard let creatingSection = self?.storyboard?.instantiateViewController(withIdentifier: "CreatingSectionViewController") as? CreatingSectionViewController else { return }
                creatingSection.editSection = self?.model.getSection(index: indexPath.row)
                self?.present(creatingSection, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            guard let self = self else { return }
            self.showAlert(index: indexPath.row)
            completion(true)
        }
        
        return UISwipeActionsConfiguration.getDeleteActionConfiguration(deleteAction: delete)
    }
}

extension SectionListViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let taskList = storyboard?.instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController else { return }
        guard let section = self.model.getSection(index: indexPath.row) else { return }
        let databaseService = DatabaseService()
        taskList.model = TaskListModel(localStore: databaseService, section: section)
        navigationController?.pushViewController(taskList, animated: true)
    }
}

extension SectionListViewController: DelegateUpdateViewSection {
    func updateSection() {
        tableView.reloadData()
    }
}
