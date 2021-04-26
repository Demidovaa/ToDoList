//
//  ColorCollectionViewCell.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 01.04.2021.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var selectedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    private func configureView() {
        colorView.roundCorners(type: .all, radius: Constants.colorButtonRounding)
        colorView.addBorder(borderColor: UIColor.black.cgColor,
                            borderWith: Constants.borderWith,
                            borderCornerRadius: Constants.colorButtonRounding)
    }
    
    func configureItem(color: UIColor) {
        colorView.backgroundColor = color
        selectedImage.isHidden = true
    }
    
    func configureSelectedItem(color: UIColor) {
        selectedImage.isHidden = false
        selectedImage.tintColor = .white
        colorView.backgroundColor = color
    }
}
