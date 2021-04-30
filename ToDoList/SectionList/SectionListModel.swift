//
//  ModelSectionList.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import Foundation
import UIKit.UIColor

protocol SectionListModeling {
    var delegateUpdate: DelegateUpdateViewSection? { get set }
    var sectionsCount: Int { get }
    var selectedEditIndex: Int? { get set }
    
    func getInfoTask(index: Int) -> (all: Int, completed: Int)?
    func getSection(index: Int) -> Section?
    func fetchSectionList()
    func setSection(section: Section)
    func deleteSection(index: Int)
    func updateSection(name: String?, color: Data?)
}

protocol DelegateUpdateViewSection: AnyObject {
    func updateSection()
}

class SectionListModel: SectionListModeling {
    
    private var localStore: DatabaseServicing
    
    weak var delegateUpdate: DelegateUpdateViewSection?
    
    private var sectionList: [Section]? {
        didSet {
            delegateUpdate?.updateSection()
        }
    }
        
    init(localStore: DatabaseServicing) {
        self.localStore = localStore
    }
    
    //MARK: - Func for protocol SectionListModeling
    
    var sectionsCount: Int {
        sectionList?.count ?? 0
    }
    
    var selectedEditIndex: Int?
            
    func getSection(index: Int) -> Section? {
        return sectionList?[index]
    }
    
    func getInfoTask(index: Int) -> (all: Int, completed: Int)? {
        guard let section = sectionList?[index] else { return nil }
        let all = section.tasks.count
        let completed = section.tasks.filter({ $0.isCompleted }).count        
        return (all, completed)
    }
    
    func fetchSectionList() {
        sectionList = localStore.getSavedObjects(type: Section.self)
    }
    
    func setSection(section: Section) {
        if sectionList?.first(where: { $0 == section}) == nil {
            sectionList?.append(section)
        }
        localStore.saveObject(section)
    }
    
    func deleteSection(index: Int) {
        guard let section = sectionList?.remove(at: index) else { return }
        localStore.removeObject(section)
    }
    
    func updateSection(name: String?, color: Data?) {
        guard let index = selectedEditIndex else { return }
        localStore.modify { [weak self] in
            if let name = name,
               let color = color {
                self?.sectionList?[index].name = name
                self?.sectionList?[index].color = color
            }
        }
    }
}
