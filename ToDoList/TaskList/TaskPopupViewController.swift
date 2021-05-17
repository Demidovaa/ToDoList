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
    
    let datePicker = UIDatePicker()
    private var date: Date?
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var tapButton: UIButton!
    @IBOutlet private weak var sheetView: UIView!
    @IBOutlet private weak var textView: UITextView!
    
    @IBOutlet private weak var heightSheetView: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstaint: NSLayoutConstraint!
    
    //MARK: - IBOutlet for action
    
    @IBOutlet private weak var actionView: UIView!
    
    @IBOutlet private weak var datePickerButton: UIButton!
    @IBOutlet private weak var dateView: UIView!
    @IBOutlet private weak var deleteDateButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var appendButton: UIButton!
    
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
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = task?.dateCompleted
        configureView()
        configureTextView()
        textView.delegate = self
        textView.setPlaceholder(text: "addTask".localized())
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
        
        dateView.backgroundColor = viewColor
        dateView.roundCorners(type: .all, radius: AppConstants.roundPopupButton)
        if let date = task?.dateCompleted {
            dateView.isHidden = false
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateView.isHidden = true
        }
        
        if viewColor == .white {
            dateView.addBorder(borderColor: UIColor.separator.cgColor,
                               borderWith: AppConstants.borderWith,
                               borderCornerRadius: AppConstants.roundPopupButton)
        }
        
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
        
        let alert = UIAlertController(title: "continueTitle".localized(),
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "continueEditing".localized(),
                                      style: .cancel,
                                      handler: { [weak self] _ in
                                        guard let self = self else { return }
                                        self.textView.becomeFirstResponder()
                                      }))
        
        alert.addAction(UIAlertAction(title: "dismiss".localized(),
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
            let newTask = Task()
            newTask.name = textView.text
            
            if date == nil && state == .editing {
                newTask.dateCompleted = nil
                
            } else if let date = date,
                      let oldDate = task?.dateCompleted,
                      oldDate != date {
                newTask.dateCompleted = date
                
            } else if let date = date {
                newTask.dateCompleted = date
                
            } else if let oldDate = task?.dateCompleted {
                newTask.dateCompleted = oldDate
            }
            
            result = .success(task: newTask)
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
            textView.text != task?.name || date != task?.dateCompleted ? showActionSheet(controller: self) : handleTask()
        case .create:
            !textView.text.isEmpty ? showActionSheet(controller: self) : handleTask()
        }
    }
    
    @IBAction private func addTask() {
        handleTask()
    }
    
    @IBAction private func openPicker(_ sender: Any) {
        guard let date = state == .editing && date != nil ? task?.dateCompleted : Date() else { return }
        let pickerController = CalendarPickerViewController(
            baseDate: date,
            selectedDateChanged: { [weak self] date in
                guard let self = self else { return }
                self.date = date
                self.dateView.isHidden = false
                self.dateLabel.text = self.dateFormatter.string(from: date)
            })
        
        present(pickerController, animated: true)
    }
    
    @IBAction private func tapDeleteDate(_ sender: Any) {
        date = nil
        UIView.animate(withDuration: 0.3) {
            self.dateView.isHidden = true
        }
    }
}
