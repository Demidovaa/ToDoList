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
    case custom
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
            
        case .custom:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    func addShadow(color: UIColor, opacity: Float = 0.7, radius: CGFloat = 4.0, size: (w: Int, h: Int)) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: size.w, height: size.h)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func addBorder(borderColor:CGColor, borderWith:CGFloat, borderCornerRadius:CGFloat){
        layer.borderWidth = borderWith
        layer.borderColor = borderColor
        layer.cornerRadius = borderCornerRadius
    }
}
