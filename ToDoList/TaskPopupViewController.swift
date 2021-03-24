//
//  TaskPopupViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 18.03.2021.
//

import UIKit

enum ResultTask {
    case success(text: String)
    case failure
}

protocol DelegateTaskHandler: class {
    func create(result: ResultTask)
    func update(result: ResultTask)
    func closePopup()
}

class TaskPopupViewController: UIViewController {
    
    private enum StatePopup {
        case create
        case editing
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tapButton: UIButton!
    @IBOutlet private weak var sheetView: UIView!
    @IBOutlet private weak var textView: UITextView!
    
    @IBOutlet private weak var actionView: UIView!
    @IBOutlet private weak var appendButton: UIButton!
    
    @IBOutlet private weak var heightSheetView: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstaint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    weak var delegateHandle: DelegateTaskHandler?
    
    var task: String? {
        willSet {
            if newValue != nil, newValue != "" {
                state = .editing
            }
        }
    }
    
    //MARK: - Private Properties
    
    private var state: StatePopup = .create
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTextView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sheetView.roundCorners(type: .top, radius: 16)
    }
    
    //MARK: - Private func
    
    private func configureView() {
        tapButton.backgroundColor = .clear
        appendButton.roundCorners(type: .all, radius: 15)
        appendButton.backgroundColor = .systemTeal
        appendButton.tintColor = .white
    }
    
    private func configureTextView() {
        textView.text = task
        textView.tintColor = .systemTeal
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 17)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            bottomConstaint.constant = keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.sheetView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide() {
        bottomConstaint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.sheetView.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    private func showActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "Do you want continue editing?",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Continue Editing",
                                      style: .cancel,
                                      handler: { [weak self] _ in
                                        guard let self = self else { return }
                                        self.textView.becomeFirstResponder()
                                      }))
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .destructive,
                                      handler: { [weak self] _ in
                                        guard let self = self else { return }
                                        self.delegateHandle?.closePopup()
                                      }))
        
        self.present(alert, animated: true)
    }
    
    private func handleTask() {
        let result: ResultTask
        if validateInput(textView: textView) {
            result = .success(text: textView.text)
        } else {
            result = .failure
        }
        
        switch state {
        case .create:
            delegateHandle?.create(result: result)
        case .editing:
            delegateHandle?.update(result: result)
        }
        
        delegateHandle?.closePopup()
    }
    
    private func validateInput(textView: UITextView) -> Bool {
        return (!textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    
    //MARK: - IBAction
    
    @IBAction private func tapScreen() {
        textView.resignFirstResponder()
        if !textView.text.isEmpty {
            showActionSheet(controller: self)
        } else {
            handleTask()
        }
    }
    
    @IBAction private func addTask() {
        handleTask()
    }
}
