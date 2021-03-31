//
//  UIView+Extension.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 18.03.2021.
//

import UIKit

enum RoundCornersType {
    case all
    case top
    case left
}

extension UIView {    
    func roundCorners(type: RoundCornersType, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        switch type {
        case .all:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
        case .left:
            self.layer.maskedCorners = [.layerMinXMinYCorner]
            
        case .top:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
}
