//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 17.03.2021.
//

import UIKit
import MobileCoreServices

class TaskListViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var addButtonView: UIView!
    
    //MARK: - Properties
    
    private var task: [TaskModel] = []
    private var currentEditTaskIndex: IndexPath?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
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
            popup.task = task[index].textTask
        }
        
        view.alpha = 0.4
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .coverVertical
        present(popup, animated: true, completion: nil)
    }
    
    private func removeCell(for indexPath: IndexPath) {
        self.task.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    //MARK: - IBAction
    
    @IBAction private func tapPlus(_ sender: Any) {
        presentingPopupFor(indexPath: nil)
    }
}

//MARK: - Extension

extension TaskListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Current task:" : "Completed task:"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return task.filter { !$0.isCompleted }.count
        } else {
            return task.filter { $0.isCompleted }.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        cell.configureCell(text: task[indexPath.row].textTask)
        cell.completedHandler = { [weak self] isCompleted in
            guard let self = self else { return }
            self.task[indexPath.row].isCompleted = isCompleted
            self.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var actions = [UIContextualAction]()
        
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            guard let self = self else { return }
            self.removeCell(for: indexPath)
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

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentEditTaskIndex = indexPath
        presentingPopupFor(indexPath: indexPath)
    }
}

//MARK: - Drag&Drop

extension TaskListViewController:  UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.task[indexPath.row].textTask
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    /// This method moves a cell from source indexPath to destination indexPath within the same collection view. It works for only 1 item.
    /// If multiple items selected, no reordering happens.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UITableViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: tableView in which reordering needs to be done.
    
    private func reorderItems(coordinator: UITableViewDropCoordinator, destinationIndexPath: IndexPath, tableView: UITableView) {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= tableView.numberOfRows(inSection: 0) {
                dIndexPath.row = tableView.numberOfRows(inSection: 0) - 1
            }
            tableView.performBatchUpdates({
                self.task.remove(at: sourceIndexPath.row)
                self.task.insert(.init(textTask: item.dragItem.localObject as! String,
                                       backgroundColor: .black,
                                       isCompleted: false), at: dIndexPath.row)
                
                tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
                tableView.insertRows(at: [dIndexPath], with: .automatic)
            })
            
            coordinator.drop(items.first!.dragItem, toRowAt: dIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if tableView.hasActiveDrag {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UITableViewDropProposal(operation: .forbidden)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, tableView: tableView)
        default:
            return
        }
    }
}

extension TaskListViewController: DelegateTaskHandler {
    func create(result: ResultTask) {
        switch result {
        case .success(let text):
            task.append(.init(textTask: text, backgroundColor: .systemTeal, isCompleted: false))
            tableView.insertRows(at: [IndexPath(row: self.task.count - 1, section: 0)],
                                 with: .automatic)
        case .failure:
            break
        }
    }
    
    func update(result: ResultTask) {
        guard let currentEditTaskIndex = currentEditTaskIndex else { return }
        switch result {
        case .success(let text):
            task[currentEditTaskIndex.row].textTask = text
            tableView.reloadRows(at: [currentEditTaskIndex], with: .automatic)
        case .failure:
            removeCell(for: currentEditTaskIndex)
        }
    }
    
    func closePopup() {
        self.dismiss(animated: true)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
}
