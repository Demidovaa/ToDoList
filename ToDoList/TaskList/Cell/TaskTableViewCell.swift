//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 17.03.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var textTaskLabel: UILabel!
    @IBOutlet private weak var rearView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configureView() {
        rearView.round(radius: 6)
        rearView.backgroundColor = .gray
        
        textTaskLabel.numberOfLines = 0
        textTaskLabel.lineBreakMode = .byWordWrapping
    }
    
}
