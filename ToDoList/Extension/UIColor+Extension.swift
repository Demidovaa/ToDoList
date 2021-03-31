//
//  UIColor+Extension.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 31.03.2021.
//

import UIKit

extension UIColor {
    static func getColor(from data: Data) -> UIColor? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
    
    func encode() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}
