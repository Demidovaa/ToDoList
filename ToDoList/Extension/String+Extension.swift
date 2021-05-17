//
//  String+Extension.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 27.04.2021.
//

import Foundation

extension String {
    func styled(_ style: TextStyle) -> NSMutableAttributedString {
        switch style {
        case .text:
            return NSMutableAttributedString(string: self, attributes: NSAttributedString.text)
        case .strikethroughText:
            return NSMutableAttributedString(string: self, attributes: NSAttributedString.strikethroughText)
        }
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
