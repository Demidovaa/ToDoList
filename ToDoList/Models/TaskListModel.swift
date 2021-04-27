//
//  ModelTaskList.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 27.04.2021.
//

import Foundation

protocol TaskListModeling: class {
    var taskCount: Int { get }
    
    func getTask(from index: Int) -> Task
    func removeTask(index: Int)
    func addTask(task: Task)
    func insertTask(task: Task, index: Int)
    func completeTask(index: Int, isComplete: Bool)
}

class TaskListModel: TaskListModeling {
    private var localStore: DatabaseServicing
    
    private var section: Section
    
    init(localStore: DatabaseServicing, section: Section) {
        self.localStore = localStore
        self.section = section
    }
    
    var taskCount: Int {
        section.tasks.count
    }
    
    func getTask(from index: Int) -> Task {
        return section.tasks[index]
    }
    
    func addTask(task: Task) {
        localStore.modify { [weak self] in
            self?.section.tasks.append(task)
        }
    }
    
    func completeTask(index: Int, isComplete: Bool) {
        localStore.modify { [weak self] in
            self?.section.tasks[index].isCompleted = isComplete
        }
    }
    
    func insertTask(task: Task, index: Int) {
        localStore.modify { [weak self] in
            self?.section.tasks.insert(task, at: index)
        }
    }
    
    func removeTask(index: Int) {
        localStore.removeObject(section.tasks[index])
    }
}
