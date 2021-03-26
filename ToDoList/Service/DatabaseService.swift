//
//  DatabaseService.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import RealmSwift
 
protocol DatabaseServicing {
    func saveObject<T>(_ object: T) where T: Object
    func removeObject<T>(_ object: T) where T: Object
    func getSavedObjects<T>(type: T.Type) -> [T]? where T: Object
    func modify(_ block: () -> Void)
}

class DatabaseService: DatabaseServicing {
    
    init() {
        loadStartSections()
    }
    
    private func loadStartSections() {
        if UserDefaults.isFirstLaunch() {
            let sectionToday = Section()
            sectionToday.name = "Today"
            sectionToday.colorName = "green"
            let sectionImportant = Section()
            sectionImportant.name = "Important"
            sectionImportant.colorName = "green"
            
            [sectionToday, sectionImportant].forEach { saveObject($0) }
        }
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func saveObject<T>(_ object: T) where T: Object {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(object, update: .modified)
            try realm.commitWrite()
        }
        catch (let error) {
            print(error)
        }
    }
    
    func removeObject<T>(_ object: T) where T: Object {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(object)
            try realm.commitWrite()
        }
        catch (let error) {
            print(error)
        }
    }
    
    func getSavedObjects<T>(type: T.Type) -> [T]? where T: Object {
        do {
            let realm = try Realm()
            let obj = realm.objects(T.self)
            return obj.map { $0 }
        }
        catch (let error) {
            print(error)
            return []
        }
    }

    func modify(_ block: () -> Void) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            block()
            try realm.commitWrite()
        }
        catch (let error) {
            print(error)
        }
    }
}

