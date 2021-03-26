//
//  TaskModel.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 23.03.2021.
//

import UIKit
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var notes = ""
    @objc dynamic var isCompleted: Bool = false
    
}

class Section: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var colorName = ""
    let tasks = List<Task>()
    
    override class func primaryKey() -> String { // section has a unique name
        return "name"
    }
}

struct TaskModel {
    var textTask: String
    var backgroundColor: UIColor
    var isCompleted: Bool
}
