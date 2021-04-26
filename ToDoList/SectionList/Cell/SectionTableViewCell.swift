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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureContentView()
    }
    
    //MARK: - Private Func
    
    private func configureContentView() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        colorView.roundCorners(type: .custom, radius: 7.5)
        backView.roundCorners(type: .all, radius: 15)
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        countTaskLabel.textColor = .systemGray2
        countTaskLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    //MARK: - Configure cell
    
    func confugureCell(title: String, count: Int, completedTask: Int = 0, color: UIColor) {
        nameLabel.text = title
        countTaskLabel.text = "\(completedTask)/\(count) completed"
        colorView.backgroundColor = color
        backView.layer.masksToBounds = false
        backView.addShadow(color: .black, radius: 1.0, size: (3,3))
        if color == .white {
            colorView.layer.borderWidth = 1
            colorView.layer.borderColor = UIColor.separator.cgColor
        }
    }
}
