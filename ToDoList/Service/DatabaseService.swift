//
//  DatabaseService.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import RealmSwift
import Realm
 
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
            sectionToday.name = "today".localized()
            guard let color = UIColor.systemYellow.encode() else { return }
            sectionToday.color = color
            let sectionImportant = Section()
            sectionImportant.name = "important".localized()
            sectionImportant.color = color
        
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
            realm.delete(object, cascading: true)
            try realm.commitWrite()
        }
        catch (let error) {
            print(error)
        }
    }
    
    func getSavedObjects<T>(type: T.Type) -> [T]? where T: Object {
        do {
            let realm = try Realm()
            return realm.objects(T.self)
                .sorted(byKeyPath: #keyPath(Section.date), ascending: true)
                .map { $0 }
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

protocol CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool)
}

extension Realm: CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object {
        for obj in objects {
            delete(obj, cascading: cascading)
        }
    }
    
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool) {
        if cascading {
            cascadeDelete(entity)
        } else {
            delete(entity)
        }
    }
}

private extension Realm {
    private func cascadeDelete(_ entity: RLMObjectBase) {
        guard let entity = entity as? Object else { return }
        var toBeDeleted = Set<RLMObjectBase>()
        toBeDeleted.insert(entity)
        while !toBeDeleted.isEmpty {
            guard let element = toBeDeleted.removeFirst() as? Object,
                !element.isInvalidated else { continue }
            resolve(element: element, toBeDeleted: &toBeDeleted)
        }
    }
    
    private func resolve(element: Object, toBeDeleted: inout Set<RLMObjectBase>) {
        element.objectSchema.properties.forEach {
            guard let value = element.value(forKey: $0.name) else { return }
            if let entity = value as? RLMObjectBase {
                toBeDeleted.insert(entity)
            } else if let list = value as? RealmSwift.ListBase {
                for index in 0 ..< list._rlmArray.count {
                    if let realmObject = list._rlmArray.object(at: index) as? RLMObjectBase {
                        toBeDeleted.insert(realmObject)
                    }
                }
            }
        }
        delete(element)
    }
}

