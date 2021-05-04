//
//  NSStringAttributes+Extension.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 27.04.2021.
//

import UIKit

typealias NSStringAttributes = [NSAttributedString.Key: Any]

extension NSAttributedString {
    static var text: NSStringAttributes {
        var attributes: NSStringAttributes = [:]
        attributes[.font] = UIFont.systemFont(ofSize: 17, weight: .regular)
        attributes[.foregroundColor] = UIColor.black
        attributes[.strikethroughStyle] = 0
        return attributes
    }
    
    static var strikethroughText: NSStringAttributes {
        var attributes: NSStringAttributes = [:]
        attributes[.font] = UIFont.systemFont(ofSize: 17, weight: .regular)
        attributes[.foregroundColor] = UIColor.black
        attributes[.strikethroughStyle] = 1
        return attributes
    }
}
