//
//  TaskPopupViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 18.03.2021.
//

import UIKit

protocol DelegateTaskHandler: AnyObject {
    func create(result: TaskPopupViewController.ResultTask)
    func update(result: TaskPopupViewController.ResultTask)
    func closePopup()
}

class TaskPopupViewController: UIViewController, UITextViewDelegate {
    
    private enum StatePopup {
        case create
        case editing
    }
    
    enum ResultTask {
        case success(task: Task)
        case failure
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
    var viewColor: UIColor = .white
    var task: Task? {
        willSet {
            if newValue != nil {
                state = .editing
            }
        }
    }
    
    //MARK: - Private Properties
    
    private var state: StatePopup = .create
    private var keyboardHeight: CGFloat = 0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTextView()
        textView.delegate = self
        textView.setPlaceholder(text: "Add task description...")
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
        textViewDidChange(textView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sheetView.roundCorners(type: .top, radius: AppConstants.roundPopup)
    }
    
    //MARK: - Private func
    
    func textViewDidChange(_ textView: UITextView) {
        textView.checkPlaceholder()
    }
    
    private func configureView() {
        tapButton.backgroundColor = .clear
        appendButton.roundCorners(type: .all, radius: AppConstants.roundPopupButton)
        appendButton.backgroundColor = viewColor
        appendButton.tintColor = viewColor == .white ? .systemBlue : .white
    }
    
    private func configureTextView() {
        textView.text = task?.name
        textView.tintColor = viewColor == .white ? .systemBlue : viewColor
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: AppConstants.fontTitle)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.bottomConstaint.constant = self.keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide() {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstaint.constant = self.bottomConstaint.constant - self.keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func showActionSheet(controller: UIViewController) {
        keyboardHeight += heightSheetView.constant
        textView.resignFirstResponder()
        
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
            let task = Task()
            task.name = textView.text
            result = .success(task: task)
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
        switch state {
        case .editing:
            textView.text != task?.name ? showActionSheet(controller: self) : handleTask()
        case .create:
            !textView.text.isEmpty ? showActionSheet(controller: self) : handleTask()
        }
    }
    
    @IBAction private func addTask() {
        handleTask()
    }
}
