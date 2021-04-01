//
//  CreatingSectionViewController.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import UIKit

class CreatingSectionViewController: UIViewController {
    
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
    
    //MARK: - Private Properties
    
    private var colorSet: [UIColor] = [.systemYellow, .systemBlue, .systemGreen, .systemRed, .systemPurple, .systemTeal, .systemOrange, .systemPink, .systemIndigo, .brown, .white, .magenta]
    private var selectedIndex = 0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        registerCell()
        configureView(color: colorSet[selectedIndex])
        configureTextField(color: colorSet[selectedIndex])
    }
    
    //MARK: - Private func
    
    private func configureView(color: UIColor) {
        doneButton.isEnabled = false
        backView.roundCorners(type: .all, radius: 30)
        backView.backgroundColor = color
        listImageView.tintColor = color == .white ? .systemBlue : .white
        
        backView.layer.masksToBounds = false
        backView.addShadow(color: .black, size: (3,3))
    }
    
    private func configureTextField(color: UIColor) {
        sectionTextField.textColor = color
        sectionTextField.tintColor = color
        sectionTextField.becomeFirstResponder()
        sectionTextField.placeholder = "New name list"
        sectionTextField.clearButtonMode = .whileEditing
        sectionTextField.autocapitalizationType = .sentences
        customTextFieldView.roundCorners(type: .all, radius: 10)
        
        sectionTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    private func updateUI(color: UIColor) {
        backView.backgroundColor = color
        listImageView.tintColor = color == .white ? .systemBlue : .white
        sectionTextField.textColor = color
        sectionTextField.tintColor = color
    }
    
    private func registerCell() {
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
    
    //MARK: - IBAction
    
    @IBAction private func tapCancel(_ sender: Any) {
        showAlert()
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
        selectedIndex = indexPath.row
        DispatchQueue.main.async {
            self.updateUI(color: self.colorSet[self.selectedIndex])
        }
        collectionView.reloadData()
    }
}
