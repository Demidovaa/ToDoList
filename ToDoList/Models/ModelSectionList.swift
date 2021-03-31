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
    
    func getFormat(at index: Int) -> (name: String, color: UIColor)?
    func fetchSectionList()
    func setSection(section: Section)
    func deleteSection(index: Int)
}

protocol DelegateUpdateViewSection: class {
    func updateSection()
}

class SectionListModel: SectionListModeling {
    
    private var localStore: DatabaseServicing
    
    private var sectionList: [Section]? {
        didSet {
            delegateUpdate?.updateSection()
        }
    }
    
    var sectionsCount: Int {
        sectionList?.count ?? 0
    }
    
    func getFormat(at index: Int) -> (name: String, color: UIColor)? {
        guard let section = sectionList?[index],
              let color = UIColor.getColor(from: section.color) else { return nil }
        return (name: section.name, color: color)
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
    
    func deleteSection(index: Int) {
        guard let section = sectionList?.remove(at: index) else { return }
        localStore.removeObject(section)
    }
}
