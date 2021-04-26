//
//  UISwipeActionsConfiguration+Extension.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 26.04.2021.
//

import UIKit

extension UISwipeActionsConfiguration {
    static func getDeleteActionConfiguration(deleteAction: UIContextualAction) -> UISwipeActionsConfiguration {
        var actions = [UIContextualAction]()
        
        let configureImage = UIImage.SymbolConfiguration(pointSize: 12.0, weight: .bold, scale: .large)
        deleteAction.image = UIImage(systemName: "trash",
                               withConfiguration: configureImage)?.withTintColor(.white, renderingMode: .alwaysTemplate).addBackgroundCircle(.systemRed)
        deleteAction.backgroundColor = .systemBackground // Update color
        
        actions.append(deleteAction)
        
        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
}
