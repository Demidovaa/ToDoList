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
        nameLabel.font = UIFont.systemFont(ofSize: Constants.fontTitle)
        countTaskLabel.font = UIFont.systemFont(ofSize: Constants.fontSubtitle)
        
        colorView.roundCorners(type: .custom, radius: Constants.cellFlagRounding)
        backView.roundCorners(type: .all, radius: Constants.cellRounding)
        backView.addBorder(borderColor: UIColor.separator.cgColor,
                           borderWith: Constants.borderWith,
                           borderCornerRadius: Constants.cellRounding)
    }
    
    //MARK: - Configure cell
    
    func confugureCell(title: String, count: Int = 0, completedTask: Int = 0, color: UIColor) {
        nameLabel.text = title
        countTaskLabel.text = "\(completedTask)/\(count) completed"
        colorView.backgroundColor = color
        backView.layer.masksToBounds = false
        backView.addShadow(color: .black,
                           radius: Constants.cellShadowRounding,
                           size: Constants.sizeShadow)
        if color == .white {
            colorView.addBorder(borderColor: UIColor.separator.cgColor,
                                borderWith: Constants.borderWith,
                                borderCornerRadius: Constants.cellFlagRounding)
        }
    }
    
    @IBAction func tapButton(_ sender: Any) {
        completedHandler?()
    }
}
