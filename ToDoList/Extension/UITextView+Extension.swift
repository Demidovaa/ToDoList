//
//  UITextView+Extension.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 27.04.2021.
//

import UIKit

extension UITextView {
    func setPlaceholder(text: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 1
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.placeholderText
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
    }

    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(1) as? UILabel
        placeholderLabel?.isHidden = !self.text.isEmpty
    }

}
