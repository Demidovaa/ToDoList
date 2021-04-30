//
//  CreatingSectionViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import UIKit

class CreatingSectionViewController: UIViewController {
    
    private enum State {
        case create
        case editing
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var listImageView: UIImageView!
    @IBOutlet private weak var customTextFieldView: UIView!
    @IBOutlet private weak var sectionTextField: UITextField!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    var completionHandler: ((Section) -> Void)?
    var editSection: Section? {
        didSet {
            self.state = .editing
        }
    }
    
    //MARK: - Private Properties
    
    // Model Data
    
    private var state: State = .create
    private var colorSet: [UIColor] = [.systemYellow, .systemBlue, .systemGreen, .systemRed, .systemPurple, .systemTeal, .systemOrange, .systemPink, .systemIndigo, .brown, .white, .magenta]
    private var selectedIndex = 0 {
        didSet {
            selectedColor = colorSet[selectedIndex]
            collectionView.reloadData()
        }
    }
    private var selectedColor: UIColor = .systemYellow
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //MARK: - Private func
    
    private func updateUI() {
        updateSelectedIndexIfNeeded()
        configureModalNavigationItems()
        configureImageViewSelectedColor(selectedColor)
        configureTextField(selectedColor)
        configureCollectionView()
    }
    
    private func updateSelectedIndexIfNeeded() {
        guard let editSection = editSection,
              let color = UIColor.getColor(from: editSection.color) else {
            return
        }
        selectedIndex = colorSet.firstIndex(of: color) ?? 0
    }
    
    private func configureModalNavigationItems() {
        switch state {
        case .create:
            titleLabel.text = "New Section"
            doneButton.isEnabled = false
        case .editing:
            titleLabel.text = "Editing Section"
            doneButton.isEnabled = true
        }
    }
        
    private func configureImageViewSelectedColor(_ color: UIColor) {
        backView.roundCorners(type: .all, radius: AppConstants.buttonRounding)
        backView.backgroundColor = color
        backView.layer.masksToBounds = false
        backView.addShadow(color: .black, size: AppConstants.sizeShadow)
        listImageView.tintColor = color == .white ? .systemBlue : .white
    }
    
    private func configureTextField(_ color: UIColor) {
        sectionTextField.text = state == .editing ? editSection?.name : ""
        sectionTextField.textColor = color
        sectionTextField.tintColor = color
        sectionTextField.becomeFirstResponder()
        sectionTextField.placeholder = "New name list"
        sectionTextField.clearButtonMode = .whileEditing
        sectionTextField.autocapitalizationType = .sentences
        customTextFieldView.roundCorners(type: .all, radius: AppConstants.textFieldRounding)
        sectionTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ColorCollectionViewCell")
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
    
    private func updateColorViews() {
        backView.backgroundColor = selectedColor
        listImageView.tintColor = selectedColor == .white ? .systemBlue : .white
        sectionTextField.textColor = selectedColor
        sectionTextField.tintColor = selectedColor
    }
    
    //MARK: - IBAction
    
    private func tapColor(index: Int) {
        selectedIndex = index
        updateColorViews()
    }
    
    @IBAction private func tapCancel(_ sender: Any) {
        if sectionTextField.text != "" && editSection?.name != sectionTextField.text {
            showAlert()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction private func tapDone(_ sender: Any) {
        if let text = sectionTextField.text, !text.isEmpty,
           let color = colorSet[selectedIndex].encode() {
            let section = Section()
            section.name = text
            section.color = color
            completionHandler?(section)
        }
    }
}

extension CreatingSectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell" , for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == selectedIndex {
            item.configureSelectedItem(color: colorSet[indexPath.row])
        } else {
            item.configureItem(color: colorSet[indexPath.row])
        }
        return item
    }
}

extension CreatingSectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapColor(index: indexPath.row)
    }
}
