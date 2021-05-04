//
//  ModelTaskList.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 27.04.2021.
//

import Foundation
import UIKit.UIColor

protocol TaskListModeling: AnyObject {
    var taskCount: Int { get }
    
    func getTask(from index: Int) -> Task
    func removeTask(from index: Int)
    func add(task: Task)
    func update(task: Task, action: TaskListModel.Modify, from index: Int)
    func getInfoSection() -> (name: String, color: UIColor)?
}

class TaskListModel: TaskListModeling {
    
    enum Modify {
        case changeName
        case changeDateCompleted
        case changeState(isCompleted: Bool)
        case insertTask
    }
    
    private var localStore: DatabaseServicing
    
    private var section: Section 
    
    init(localStore: DatabaseServicing, section: Section) {
        self.localStore = localStore
        self.section = section
    }
    
    //MARK: - Func for protocol TaskListModeling
    
    var taskCount: Int {
        section.tasks.count
    }
    
    func getTask(from index: Int) -> Task {
        return section.tasks[index]
    }
    
    func getInfoSection() -> (name: String, color: UIColor)? {
        guard let color = UIColor.getColor(from: section.color) else { return nil }
        return (name: section.name, color: color)
    }
    
    func add(task: Task) {
        localStore.modify { [weak self] in
            self?.section.tasks.append(task)
        }
    }
    
    func update(task: Task, action: Modify, from index: Int) {
        localStore.modify { [weak self] in
            switch action {
            case .changeName:
                self?.section.tasks[index].name = task.name
            case .changeState(let isCompleted):
                self?.section.tasks[index].isCompleted = isCompleted
            case .insertTask:
                self?.section.tasks.insert(task, at: index)
            case .changeDateCompleted:
                self?.section.tasks[index].dateCompleted = task.dateCompleted
            }
        }
    }
    
    func removeTask(from index: Int) {
        localStore.removeObject(section.tasks[index])
    }
}
