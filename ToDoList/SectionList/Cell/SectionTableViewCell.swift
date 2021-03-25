//
//  SectionTableViewCell.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 25.03.2021.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var backImageView: UIView!
    @IBOutlet private weak var sectionImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var countTaskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureContentView()
    }
    
    private func configureContentView() {
        self.accessoryType = .disclosureIndicator
        
        backImageView.roundCorners(type: .all, radius: 12.5)
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        countTaskLabel.textColor = .systemGray2
        countTaskLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    func confugureCell(title: String, count: Int, color: UIColor) {
        nameLabel.text = title
        countTaskLabel.text = "\(count)"
        backImageView.backgroundColor = color
        backImageView.tintColor = color == .white ? .systemBlue : .white
    }
}
