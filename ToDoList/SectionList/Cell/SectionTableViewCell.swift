//
//  SectionTableViewCell.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var countTaskLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    
    var completedHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureContentView()
    }
    
    //MARK: - Private Func
    
    private func configureContentView() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        countTaskLabel.textColor = .systemGray2
        nameLabel.font = UIFont.systemFont(ofSize: AppConstants.fontTitle)
        countTaskLabel.font = UIFont.systemFont(ofSize: AppConstants.fontSubtitle)
        
        colorView.roundCorners(type: .custom, radius: AppConstants.cellFlagRounding)
        backView.roundCorners(type: .all, radius: AppConstants.cellRounding)
        backView.addBorder(borderColor: UIColor.separator.cgColor,
                           borderWith: AppConstants.borderWith,
                           borderCornerRadius: AppConstants.cellRounding)
    }
    
    //MARK: - Configure cell
    
    func confugureCell(title: String, count: Int = 0, completedTask: Int = 0, color: UIColor) {
        nameLabel.text = title
        countTaskLabel.text = "\(completedTask)/\(count)" + "completedTask".localized()
        colorView.backgroundColor = color
        backView.layer.masksToBounds = false
        backView.addShadow(color: .black,
                           radius: AppConstants.cellShadowRounding,
                           size: AppConstants.sizeShadow)
        if color == .white {
            colorView.addBorder(borderColor: UIColor.separator.cgColor,
                                borderWith: AppConstants.borderWith,
                                borderCornerRadius: AppConstants.cellFlagRounding)
        }
    }
    
    @IBAction func tapButton(_ sender: Any) {
        completedHandler?()
    }
}
