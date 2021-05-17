//
//  PopoverViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 06.05.2021.
//

import UIKit

class PopoverViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let style: StylePopover = .informational
    
    //MARK: - Data for Static Cell
    
    private let information = ["firstInfoLine".localized(),
                               "secondInfoLine".localized(),
                               "thirdInfoLine".localized()]
    
    //MARK: - Lifeсycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(cellType: PopoverTableViewCell.self)
    }
}

extension PopoverViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: PopoverTableViewCell.self, for: indexPath)
        switch style {
        case .informational:
            cell.configureCell(style, text: information[indexPath.row])
        }
        return cell
    }
}
