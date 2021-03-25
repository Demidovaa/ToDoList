//
//  DatabaseService.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import Foundation
import RealmSwift

class DatabaseService {
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

