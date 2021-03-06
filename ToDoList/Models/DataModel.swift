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
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var dateCompleted: Date?
}

class Section: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var color = Data()
    let tasks = List<Task>()
    
    override class func primaryKey() -> String { 
        return "id"
    }
}
