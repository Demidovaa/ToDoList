//
//  CreatingSectionViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import UIKit

class CreatingSectionViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var listImageView: UIImageView!
    @IBOutlet private weak var customTextFieldView: UIView!
    @IBOutlet private weak var sectionTextField: UITextField!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var color: UIColor = .white
    
    var completionHandler: ((String, UIColor) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(color: color)
        configureTextField(color: color)
    }
    
    private func configureView(color: UIColor) {
        doneButton.isEnabled = false
        backView.roundCorners(type: .all, radius: 30)
        backView.backgroundColor = color
        listImageView.tintColor = color == .white ? .systemBlue : .white
    }
    
    private func configureTextField(color: UIColor) {
        sectionTextField.textColor = color
        sectionTextField.tintColor = color
        sectionTextField.becomeFirstResponder()
        sectionTextField.clearButtonMode = .whileEditing
        sectionTextField.autocapitalizationType = .sentences
        customTextFieldView.roundCorners(type: .all, radius: 10)
        
        sectionTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)

                alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Discard Changes",
                                              style: .destructive,
                                              handler: { [weak self] _ in
                                                guard let self = self else { return }
                                                self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
    @IBAction private func tapCancel(_ sender: Any) {
        showAlert()
    }
    
    @IBAction private func tapDone(_ sender: Any) {
        if let text = sectionTextField.text, !text.isEmpty {
            completionHandler?(text, .white)
        }
    }
}
