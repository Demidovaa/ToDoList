//
//  TaskPopupViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 18.03.2021.
//

import UIKit

class TaskPopupViewController: UIViewController {
    
    @IBOutlet private weak var sheetView: UIView!
    @IBOutlet private weak var tapButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var hightSheetView: NSLayoutConstraint!
    
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTextView()
        textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        hightSheetView.constant += textView.text.isEmpty ? keyboardHeight : keyboardHeight + textView.contentSize.height
    }
    
    private func configureView() {
        tapButton.backgroundColor = .clear
        sheetView.backgroundColor = .gray
        sheetView.roundCorners(type: .top, radius: 30)
    }
    
    private func configureTextView() {
        textView.tintColor = .systemTeal
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 17)
    }
    
    @IBAction private func tapScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.keyboardHeight = keyboardHeight
        }
    }
}
