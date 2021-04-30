//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 17.03.2021.
//

import UIKit
import MobileCoreServices

class TaskListViewController: UIViewController {
    
    var model: TaskListModeling!
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var addButtonView: UIView!
    
    //MARK: - Properties
    
    private var currentEditTaskIndex: IndexPath?
    private var viewColor: UIColor = .white
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        registerCell()
        setDataInSection()
        configureAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Private Func
    
    private func setDataInSection() {
        guard let formatData = model.getInfoSection() else { return }
        self.title = formatData.name
        viewColor = formatData.color
    }
    
    private func configureAddButton() {
        addButtonView.roundCorners(type: .all, radius: AppConstants.buttonRounding)
        addButtonView.layer.masksToBounds = false
        addButtonView.addShadow(color: .black, size: AppConstants.sizeShadow)
        addButtonView.backgroundColor = viewColor
        addButton.tintColor = viewColor == .white ? .systemBlue : .white
    }
    
    private func registerCell() {
        tableView.register(cellType: TaskTableViewCell.self)
    }
    
    private func presentingPopupFor(indexPath: IndexPath?) {
        guard let popup = storyboard?.instantiateViewController(withIdentifier: "TaskPopupViewController") as? TaskPopupViewController else { return }
        popup.delegateHandle = self
        popup.viewColor = viewColor
        
        if let index = indexPath?.row {
            popup.task = model.getTask(from: index)
        }
        
        view.alpha = 0.4
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .coverVertical
        present(popup, animated: true, completion: nil)
    }
    
    private func removeCell(for indexPath: IndexPath) {
        model.removeTask(from: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    //MARK: - IBAction
    
    @IBAction private func tapPlus(_ sender: Any) {
        navigationController?.view.alpha = 0.4
        presentingPopupFor(indexPath: nil)
    }
}

//MARK: - Extension

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.taskCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Task:"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = model.getTask(from: indexPath.row)
        let cell = tableView.dequeueReusableCell(with: TaskTableViewCell.self, for: indexPath)
        cell.configureCell(text: task.name, styleCell: .init(rawValue: task.isCompleted), color: viewColor) { [weak self] state in
            self?.model.update(task: task, action: .changeState(isCompleted: state), from: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: nil) { [weak self] (contextualAction, view, completion) in
            guard let self = self else { return }
            self.removeCell(for: indexPath)
            completion(true)
        }
        
        return UISwipeActionsConfiguration.getDeleteActionConfiguration(deleteAction: delete)
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
        let item = self.model.getTask(from: indexPath.row).name
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
                self.model.removeTask(from: sourceIndexPath.row)
                let task: Task = .init() // BUG
                task.name = item.dragItem.localObject as! String
                self.model.update(task: task, action: .insertTask, from: dIndexPath.row)
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
    func create(result: TaskPopupViewController.ResultTask) {
        switch result {
        case .success(let task):
            model.add(task: task)
            tableView.insertRows(at: [IndexPath(row: self.model.taskCount - 1, section: 0)],
                                 with: .automatic)
        case .failure:
            break
        }
    }
    
    func update(result: TaskPopupViewController.ResultTask) {
        guard let currentEditTaskIndex = currentEditTaskIndex else { return }
        switch result {
        case .success(let task):
            model.update(task: task, action: .changeName, from: currentEditTaskIndex.row)
            tableView.reloadRows(at: [currentEditTaskIndex], with: .automatic)
        case .failure:
            removeCell(for: currentEditTaskIndex)
        }
    }
    
    func closePopup() {
        self.dismiss(animated: true)
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
            self.navigationController?.view.alpha = 1.0
        }
    }
}
