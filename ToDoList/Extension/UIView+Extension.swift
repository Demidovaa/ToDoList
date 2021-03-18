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
}

extension UIView {    
    func roundCorners(type: RoundCornersType, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        switch type {
        case .all:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .top:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    func subviews<T:UIView>(ofType WhatType:T.Type) -> [T] {
        var result = self.subviews.compactMap { $0 as? T }
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType:WhatType))
        }
        return result
    }
}
