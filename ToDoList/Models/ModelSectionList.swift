//
//  ModelSectionList.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import Foundation

protocol SectionListModeling {
    var delegateUpdate: DelegateUpdateViewSection? { get set }
    
    var sectionList: [Section]? { get }
    
    func fetchSectionList()
    func setSection(section: Section)
}

protocol DelegateUpdateViewSection: class {
    func updateSection()
}

class SectionListModel: SectionListModeling {
    
    private var localStore: DatabaseServicing
    
    var sectionList: [Section]? {
        didSet {
            delegateUpdate?.updateSection()
        }
    }
    
    weak var delegateUpdate: DelegateUpdateViewSection?
   
    init(localStore: DatabaseServicing) {
        self.localStore = localStore
    }
    
    func fetchSectionList() {
        sectionList = localStore.getSavedObjects(type: Section.self)
    }
    
    func setSection(section: Section) {
        sectionList?.append(section)
        localStore.saveObject(section)
    }
}
